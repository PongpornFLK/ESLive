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


if __name__ == "__main__":
    from app.db import SessionLocal
    from app.models.match import PatchNote

    db = SessionLocal()
    patch = db.query(PatchNote).filter(PatchNote.version == "13.05").first()

    content = getPatchGameURL(patch.raw_source_url)

    print(f"URL    : {patch.raw_source_url}")
    print(f"Length : {len(content)} chars")

    print("\n--- markdown markers (found / target) ---")
    # 67 = <li> ทั้งหมดในหน้าเว็บ, 5 อันเป็นตัวครอบรายการซ้อนที่ไม่มีข้อความ -> เหลือ 62
    target = {"# ": 3, "## ": 6, "### ": 0, "- ": 62}
    for mark, want in target.items():
        found = len(re.findall(rf"^{re.escape(mark)}", content, re.M))
        flag = "OK" if found == want else "..."
        print(f"  {mark:<6} {found:>4} / {want:<4} {flag}")
    found_bold = content.count("**")
    print(f"  {'**':<6} {found_bold:>4} / {40:<4} {'OK' if found_bold == 40 else '...'}")

    print("\n--- leftover HTML tags (target 0) ---")
    leftover = re.findall(r"<[^>]+>", content)
    print(f"  {len(leftover)} left  {leftover[:5]}")

    print("\n--- first 20 lines ---")
    for line in content.split("\n")[:100]:
        print(f"{line}")
