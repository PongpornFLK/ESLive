import re
import html

from app.core.http import http


def getPatchRiot(game: str, zone: str):

    res = http.get(f"https://data.rito.news/{game}/{zone}/news.json")

    return res.json()


def getPatchGameURL(raw_source_url: str):

    content_html = http.get(f"{raw_source_url}")
    content_tag = content_html.text
    find_tag = re.findall(
        r'data-testid="rich-text-html"[^>]*>(.*?)</div></div>', content_tag, re.S
    )
    tag_length = max(find_tag, key=len)
    tag_name_lip = re.sub(r"<li[^>]*>\s*<p[^>]*>", "\n- ", tag_length)
    tag_name_li = re.sub(r"<li[^>]*>\s*", "\n- ", tag_name_lip)
    tag_name_p = re.sub(r"<p[^>]*>\s*", "\n\n", tag_name_li)
    tag_name_h1 = re.sub(r"<h1[^>]*>\s*", "\n# ", tag_name_p)
    tag_name_h2 = re.sub(r"<h2[^>]*>\s*", "\n## ", tag_name_h1)
    tag_name_h3 = re.sub(r"<h3[^>]*>\s*", "\n### ", tag_name_h2)
    tag_name_st = re.sub(r"</?strong[^>]*>", "**", tag_name_h3)
    tag_name_em = re.sub(r"</?em[^>]*>", "*", tag_name_st)
    tag_sign = re.sub("<[^>]+>", "", tag_name_em)
    tag_sym = html.unescape(tag_sign)
    tag_indent = re.sub(r"^[ \t]+", "", tag_sym, flags=re.M)
    tag_name_blank = re.sub(r"^-[ \t]*$", "", tag_indent, flags=re.M)
    content = tag_name_blank.strip()

    return content
