### This shell script creates a new directory for applying a graduate school exam
### Avialable configuration options:
###  [Documents] - Requirement documents.
###  [Timetable] - Important events.
###  [Reference] - URL to the related online resourses.

#!/bin/bash

function print_preview() {
        HTML_SHOW_1=""
        HTML_SHOW_4=""

        for requirement in $APPLICATION/*; do
            if [[ -d $requirement || $requirement == "$APPLICATION/Reference.conf" || $requirement == "$APPLICATION/index.html" || $requirement == "$APPLICATION/requirements.md" ]]; then
                continue
            fi
            path=$(realpath $requirement)
            requirement=$(basename $requirement)
            HTML_SHOW_1+="
                <li class=\"list-group-item checklist-item\">
                    <input type=\"checkbox\" id=\"$requirement\" class=\"form-check-input\"><a href=\"$path\" target=\"_blank\">$requirement</a>
                </li>
            "
            HTML_SHOW_4+="
            checklistItems.push('$requirement');
            "
        done

        HTML_SHOW_2=""
        for timetable in $APPLICATION/Timetable/*; do
            HTML_SHOW_2+="
                <tr>
                    <td>$(basename "$timetable")</td>
                    <td>$(cat "$timetable")</td>
                </tr>
            "
        done

        HTML_SHOW_3=""
        if [[ -f "$APPLICATION/Reference.conf" ]]; then
            while IFS= read -r reference; do
                NAME=$(echo "$reference" | awk '{print $1}')
                URL=$(echo "$reference" | awk '{print $2}')
                HTML_SHOW_3+="
                    <tr>
                        <td>$NAME</td>
                        <td><a href=\"$URL\" target=\"_blank\">$URL</a></td>
                    </tr>
                "
            done < "$APPLICATION/Reference.conf"
        fi

HTML_CONTENT_1="
<!DOCTYPE html>
<html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\">
        <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
        <title>$APPLICATION</title>
        <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css\" rel=\"stylesheet\">
        <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js\"></script>
        <link href=\"https://cdn.datatables.net/1.13.4/css/dataTables.bootstrap5.min.css\" rel=\"stylesheet\">
        <script src=\"https://code.jquery.com/jquery-3.6.0.min.js\"></script>
        <script src=\"https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js\"></script>
        <script src=\"https://cdn.datatables.net/1.13.4/js/dataTables.bootstrap5.min.js\"></script>
        <style>
            .checklist-item {
                display: flex;
                align-items: center;
            }
            .checklist-item input {
                margin-right: 1rem;
            }
            .current-time {
                color: black;
                font-style: italic;
                margin-left: 10px; /* 顯示在標題旁邊 */
            }
            .table-responsive {
                max-width: 100%; /* 讓 table 限制在父容器的寬度內 */
                overflow-x: auto; /* 加上水平滾動條以防止 table 超出寬度 */
            }
        </style>
    </head>
    <body>
        <div class=\"container mt-5\">
        <div class=\"card shadow\">
        <div class=\"card-body\" style=\"padding: 2rem;\">
            <h1 class=\"text-primary mb-4\"><strong>$APPLICATION 研究所推甄</strong></h1>
            <div class=\"row\">
                <div class=\"col-md-6\">
                    <h2 class=\"mb-4\">文件要求</h2>
                    <ul class=\"list-group\">
                        $HTML_SHOW_1
"

HTML_CONTENT_2="
                    </ul>
                </div>
                <div class=\"col-md-6\">
                <h2 class="mb-4">重要時程<span class="current-time" id="currentTime"></span></h2>
                    <table id=\"timetable\" class=\"table table-light table-striped table-bordered table-hover\">
                        <thead>
                            <tr>
                                <th>事件</th>
                                <th>日期</th>
                            </tr>
                        </thead>
                        <tbody>
                        $HTML_SHOW_2
"

HTML_CONTENT_3="
                        </tbody>
                    </table>
                </div>
            </div>
        <div class=\"container mt-5\">
            <div class=\"row\">
            <h2 class=\"mb-4\">相關連結</h2>
            <div class=\"table-responsive\">
            <table id=\"reference\" class=\"table table-striped table-bordered table-hover\">
                <thead class="table-light">
                    <tr>
                        <th>名稱</th>
                        <th>連結</th>
                    </tr>
                </thead>
                <tbody>
                $HTML_SHOW_3
"

HTML_CONTENT_4="
                </tbody>
            </table>
        </div>
        </div>
        </div>
        </div>
        <script>
            var checklistItems = [];
            $HTML_SHOW_4
            window.onload = function() {
                checklistItems.forEach(function(itemId) {
                    const checkbox = document.getElementById(itemId);
                    const isChecked = localStorage.getItem(itemId) === 'true';
                    checkbox.checked = isChecked;
                });
            };
            checklistItems.forEach(function(itemId) {
                const checkbox = document.getElementById(itemId);
                checkbox.addEventListener('change', function() {
                    localStorage.setItem(itemId, checkbox.checked);
                });
            });
            \$(document).ready(function() {
                \$('#timetable').DataTable({
                    \"paging\": false,        // Enable pagination
                    \"searching\": false,     // Enable search/filter box
                    \"ordering\": true,      // Enable sorting
                    \"info\": true,          // Enable showing entries information
                    \"lengthChange\": true,  // Enable changing page length
                    \"pageLength\": 5,       // Default number of rows per page
                    \"language\": {
                        \"url\": \"//cdn.datatables.net/plug-ins/1.13.4/i18n/Chinese.json\"  // Use Chinese language pack
                    }
                });
            });
            \$(document).ready(function() {
                \$('#reference').DataTable({
                    \"paging\": false,        // Enable pagination
                    \"searching\": true,     // Enable search/filter box
                    \"ordering\": true,      // Enable sorting
                    \"info\": true,          // Enable showing entries information
                    \"lengthChange\": true,  // Enable changing page length
                    \"pageLength\": 5,       // Default number of rows per page
                    \"language\": {
                        \"url\": \"//cdn.datatables.net/plug-ins/1.13.4/i18n/Chinese.json\"  // Use Chinese language pack
                    }
                });
            });

            function updateCurrentTime() {
                var now = new Date();
                var year = now.getFullYear();
                var month = String(now.getMonth() + 1).padStart(2, '0'); // 月份從 0 開始
                var day = String(now.getDate()).padStart(2, '0');
                var hours = String(now.getHours()).padStart(2, '0');
                var minutes = String(now.getMinutes()).padStart(2, '0');
                var seconds = String(now.getSeconds()).padStart(2, '0');
                var timeString = year + '/' + month + '/' + day + ' ' + hours + ':' + minutes + ':' + seconds; // 使用 YYYY/MM/DD HH:MM:SS 格式
                document.getElementById('currentTime').textContent = timeString;
            }

            setInterval(updateCurrentTime, 1000);
        </script>
    </body>
</html>
"
        echo "$HTML_CONTENT_1 $HTML_CONTENT_2 $HTML_CONTENT_3 $HTML_CONTENT_4" > "$APPLICATION/index.html"
}

function create_application() {
    MODE=0
    if [[ -f $APPLICATION/requirements.md && -s $APPLICATION/requirements.md ]]; then

        echo "讀取 requirements.md 並建立相關檔案..."

        while IFS= read -r line; do

            if [[ $line == "[Documents]"* ]]; then
                echo "讀取區段 $line"
                MODE=1

            elif [[ $line == "[Timetable]"* ]]; then
                echo "讀取區段 $line"
                MODE=2
                mkdir $APPLICATION/Timetable

            elif [[ $line == "[Reference]"* ]]; then
                echo "建立文件 Reference.conf ..."
                touch $APPLICATION/Reference.conf
                echo "讀取區段 $line"
                MODE=3

            elif [[ $MODE -eq 1 ]]; then
                echo "建立文件 $line ..."
                if [[ ! -f $APPLICATION/$line ]]; then
                    touch $APPLICATION/$line 2> /dev/null
                fi

            elif [[ $MODE -eq 2 ]]; then
                if [[ ! -d $APPLICATION/Timetable ]]; then
                    echo "建立目錄 Timetable ..."
                    mkdir $APPLICATION/Timetable
                fi
                # Extract the event name and Deadline
                # e.g. "RecommendationLetterSubmision 2021/10/15"
                EVENT=$(echo $line | awk '{print $1}')
                DATE=$(echo $line | awk '{print $2}')
                touch "$APPLICATION/Timetable/$EVENT"
                echo "$DATE" > "$APPLICATION/Timetable/$EVENT"

            elif [[ $MODE -eq 3 ]]; then
                if [[ -z $line ]]; then
                    continue
                fi
                NAME=$(echo $line | awk '{print $1}')
                URL=$(echo $line | awk '{print $2}')
                echo "$NAME $URL" >> $APPLICATION/Reference.conf
            fi

        done < $APPLICATION/requirements.md 

        if [[ ! -d $APPLICATION/.ignoreupdate ]]; then
            mkdir $APPLICATION/.ignoreupdate
            echo "建立 .ignoreupdate 目錄（將不需要隨設定檔更新的檔案放在這邊）..."
        fi

    else
        echo "requirements.md 檔案不得為空"
    fi
}

case $1 in

    -n|--new)
        APPLICATION=$2
        if [[ -z APPLICATION ]]; then
            read -p "請輸入學校系所（例：台大資工）: " APPLICATION
        fi

        echo "建立新的申請「$APPLICATION」..."
        mkdir $APPLICATION
        if [[ $? -ne 0 ]]; then
            echo "建立目錄失敗"
            exit 1
        fi

        echo "建立校系需求設定檔 requirements.md ..."
        touch $APPLICATION/requirements.md
        vim $APPLICATION/requirements.md

        create_application 
        ;;

    -u|--update)
        APPLICATION=$2
        if [[ -d $APPLICATION ]]; then
            # 複製舊的設定檔
            OLD_CONFIG=$(cat $APPLICATION/requirements.md)
            # 刪除舊的資料
            rm -f $APPLICATION/Reference.conf
            # 複製舊的文件
            OLD_REQUIREMENTS=$(echo $APPLICATION/*)
            if [[ -d .tmp ]]; then
                rm -rf .tmp
            fi
            mkdir .tmp
            for file in $OLD_REQUIREMENTS; do
                if [[ -d $file ]]; then
                    if [[ $file != '.ignoreupdate' ]]; then
                        continue
                    fi
                    continue
                elif [[ ! -s $file ]]; then
                    rm -f $file
                    continue
                else
                    mv $file .tmp/
                fi
            done
            rm -rf $APPLICATION/*
            echo "更新申請「$APPLICATION」..."
            mv .tmp/* $APPLICATION/
            echo "$OLD_CONFIG" > $APPLICATION/requirements.md
            create_application
            print_preview
        else
            echo "找不到「$APPLICATION」"
        fi
        ;;

    -s|--show)
        APPLICATION=$2
        print_preview
        open $APPLICATION/index.html
        ;;

    -c|--config)
        case $2 in
            timetable)
                # Saperate by semi-colon
                NEW_CONFIG=$3
                APPLICATION=$4
                if [[ -d $APPLICATION ]]; then
                    echo "更新申請「$APPLICATION」的時間表..."
                    echo "[Documents]" >> $APPLICATION/requirements.md
                    echo "$NEW_CONFIG" >> $APPLICATION/requirements.md
                    create_application
                else
                    echo "找不到「$APPLICATION」"
                fi
                ;;
            reference)
                # Saperate by semi-colon
                NEW_CONFIG=$3
                APPLICATION=$4
                if [[ -d $APPLICATION ]]; then
                    echo "更新申請「$APPLICATION」的參考資料..."
                    echo "[Reference]" >> $APPLICATION/requirements.md
                    echo "$NEW_CONFIG" >> $APPLICATION/requirements.md
                    create_application
                else
                    echo "找不到「$APPLICATION」"
                fi
                ;;
            *)
                echo "Wrong Usage"
                ;;
        esac
        ;;

    -h|--help|*)
        echo "Usage: $0 [OPTION]"
        echo "Create a new directory for applying a graduate school exam"
        echo "Options:"
        echo "  -h, --help Display this help and exit"
        echo "  -n, --new Create a new grudate school application"
        echo "  -u, --update Update the configuration for existing application"
        echo "  -s, --show Show the human-readable information of the application" 
        exit 0
        ;;
esac

