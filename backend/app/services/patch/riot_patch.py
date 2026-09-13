import httpx
import re
import html


def getPatchRiot(game: str, zone: str):

    res = httpx.get(f"https://data.rito.news/{game}/{zone}/news.json")

    return res.json()


def getPatchGameURL(raw_source_url: str):

    content_html = httpx.get(f"{raw_source_url}")
    content_tag = content_html.text
    find_tag = re.findall(
        r'data-testid="rich-text-html"[^>]*>(.*?)</div></div>', content_tag, re.S
    )
    tag_length = max(find_tag, key=len)
    tag_name = re.sub("<(p|li|h2|h3|h4|br)[^>]*>", "\n", tag_length)
    tag_sign = re.sub("<[^>]+>", "", tag_name)
    tag_sym = html.unescape(tag_sign)
    content = tag_sym

    # print(f"Content : ${content}")

    return content
