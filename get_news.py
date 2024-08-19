#!/usr/bin/env python3

import asyncio
import subprocess
from newsapi import NewsApiClient


async def fetch_news(search_keyword: str):
    API_KEY: str = '4e85bd0e7e0f42e2a5fb61895b4f5af0'
    newsapi = NewsApiClient(api_key=API_KEY)
    top_headlines = newsapi.get_top_headlines(q=search_keyword,
                                              sources='bbc-news',
                                              category='business',
                                              language='en',
                                              country='us')
    return top_headlines


def speak_text(text: str) -> None:
    subprocess.call(["speak", text])


async def main() -> int:
    usage:  str = f'Welcome to newsapi\n    type \'g\' to hear current headline\n   type \'p\' for prev headline\n  type \'n\' for next headline\n  type \'q\' to quit\n'
    index:  int = 0
    action: str = ''
    print(usage)
    news_list = await fetch_news('bitcoin')
    title:       str = news_list['articles'][index]['title']
    description: str = news_list['articles'][index]['description']

    while True:
        speak_text(title)
        action = input('> ')
        if action == 'g':
            speak_text(description)
        elif action == 'n':
            index += 1
        elif action == 'p':
            index -= 1
        elif action == 'c':
            continue
        elif action == 'q':
            break
        else:
            pass
    exit(0)


if __name__ == '__main__':
    asyncio.run(main())
