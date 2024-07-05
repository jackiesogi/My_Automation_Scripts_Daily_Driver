from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

class RequestHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(content_length)
        command = post_data.decode('utf-8')
        
        try:
            output = subprocess.check_output(['./execute.py'], input=command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(output.encode('utf-8'))
        except subprocess.CalledProcessError as e:
            self.send_response(500)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(e.output)

    def do_GET(self):
        self.send_response(405)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write("Method Not Allowed: Use POST method to execute commands.".encode('utf-8'))

def run(server_class=HTTPServer, handler_class=RequestHandler, port=8000):
    server_address = ('', port)
    httpd = server_class(server_address, handler_class)
    print(f'Starting server on port {port}...')
    httpd.serve_forever()

if __name__ == '__main__':
    run()

