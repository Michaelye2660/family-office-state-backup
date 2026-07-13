#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""md2email.py — 简报Markdown→邮件HTML转换器（零依赖·纯stdlib）
用法: python3 routines/md2email.py briefing.txt > briefing.html
设计约束（ADJ授权来源见台账〔M〕59,2026-07-13委托人直令"简报格式优化"）:
- 只处理简报实际使用的Markdown子集: #/##/### 标题、**粗体**、- 与 1. 列表、| 表格、--- 分隔线、普通段落
- 全部样式内联(style=)——Gmail会剥离<style>块,内联是邮件HTML唯一可靠方式
- 转换失败或输入为空时以非零退出码结束,调用方须回退纯文本流程,绝不发送空正文
"""
import sys, html, re

PALETTE = {
    "text": "#1f2328", "muted": "#57606a", "border": "#d0d7de",
    "bg_soft": "#f6f8fa", "accent": "#0a5bd3", "warn_bg": "#fff8e6",
}
BASE = "font-family:-apple-system,'Segoe UI',Roboto,'PingFang SC','Microsoft YaHei',sans-serif;"

def inline(s):
    s = html.escape(s, quote=False)
    s = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", s)
    s = re.sub(r"`([^`]+)`", r"<code style='background:%s;padding:1px 4px;border-radius:3px'>\1</code>" % PALETTE["bg_soft"], s)
    return s

def flush_para(buf, out):
    if buf:
        out.append("<p style='margin:6px 0;line-height:1.65'>%s</p>" % inline(" ".join(buf)))
        buf.clear()

def flush_list(items, out, ordered):
    if items:
        tag = "ol" if ordered else "ul"
        out.append("<%s style='margin:6px 0 10px;padding-left:22px'>" % tag)
        out.extend("<li style='margin:4px 0;line-height:1.6'>%s</li>" % inline(i) for i in items)
        out.append("</%s>" % tag)
        items.clear()

def flush_table(rows, out):
    if not rows:
        return
    out.append("<table style='border-collapse:collapse;margin:8px 0;width:100%%;font-size:14px'>")
    for r, cells in enumerate(rows):
        out.append("<tr>")
        for c in cells:
            if r == 0:
                out.append("<th style='border:1px solid %s;padding:5px 8px;background:%s;text-align:left'>%s</th>" % (PALETTE["border"], PALETTE["bg_soft"], inline(c)))
            else:
                out.append("<td style='border:1px solid %s;padding:5px 8px;vertical-align:top'>%s</td>" % (PALETTE["border"], inline(c)))
        out.append("</tr>")
    out.append("</table>")
    rows.clear()

def convert(md):
    out, para, items, rows = [], [], [], []
    ordered = False
    for raw in md.splitlines():
        line = raw.rstrip()
        s = line.strip()
        if s.startswith("|") and s.endswith("|"):
            flush_para(para, out); flush_list(items, out, ordered)
            cells = [c.strip() for c in s.strip("|").split("|")]
            if all(re.fullmatch(r":?-{2,}:?", c) for c in cells):
                continue  # 对齐分隔行
            rows.append(cells); continue
        flush_table(rows, out)
        if not s:
            flush_para(para, out); flush_list(items, out, ordered); continue
        m = re.match(r"^(#{1,3})\s+(.*)$", s)
        if m:
            flush_para(para, out); flush_list(items, out, ordered)
            lvl = len(m.group(1))
            size, margin = {1: ("19px", "14px 0 6px"), 2: ("17px", "16px 0 6px"), 3: ("15px", "12px 0 4px")}[lvl]
            border = "border-bottom:1px solid %s;padding-bottom:4px;" % PALETTE["border"] if lvl <= 2 else ""
            out.append('<h%d style="%sfont-size:%s;margin:%s;%scolor:%s">%s</h%d>' % (lvl, BASE, size, margin, border, PALETTE["text"], inline(m.group(2)), lvl))
            continue
        if s in ("---", "***", "___"):
            flush_para(para, out); flush_list(items, out, ordered)
            out.append("<hr style='border:none;border-top:1px solid %s;margin:12px 0'>" % PALETTE["border"]); continue
        m = re.match(r"^[-*]\s+(.*)$", s)
        if m:
            flush_para(para, out)
            if ordered: flush_list(items, out, ordered)
            ordered = False; items.append(m.group(1)); continue
        m = re.match(r"^\d+[.)]\s+(.*)$", s)
        if m:
            flush_para(para, out)
            if not ordered: flush_list(items, out, ordered)
            ordered = True; items.append(m.group(1)); continue
        para.append(s)
    flush_para(para, out); flush_list(items, out, ordered); flush_table(rows, out)
    body = "\n".join(out)
    return ("<div style=\"%smax-width:720px;margin:0 auto;padding:12px;color:%s;font-size:15px\">%s"
            "</div>") % (BASE, PALETTE["text"], body)

def main():
    if len(sys.argv) != 2:
        sys.stderr.write("usage: md2email.py <briefing.txt>\n"); sys.exit(2)
    with open(sys.argv[1], encoding="utf-8") as f:
        md = f.read()
    if len(md.strip()) < 200:
        sys.stderr.write("input too small (<200 chars), refuse to convert\n"); sys.exit(1)
    html_out = convert(md)
    if len(html_out) < 400:
        sys.stderr.write("output too small, conversion likely failed\n"); sys.exit(1)
    sys.stdout.write(html_out)

if __name__ == "__main__":
    main()
