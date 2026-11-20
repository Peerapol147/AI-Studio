#!/bin/bash
# เรียก Apify MCP (mcp.apify.com) ด้วย JSON-RPC ผ่าน proxy (proxy ใส่ token ให้เอง ห้ามใส่ key จริง)
# ใช้: bash tools/apify_mcp.sh init            -> เปิด session (เก็บ id ใน /tmp/apify_sid)
#      bash tools/apify_mcp.sh '<json-rpc body>' -> ส่งคำขอ เช่น tools/list, tools/call (call-actor, get-actor-run, get-dataset-items)
# ถ้าได้ผลว่าง = session หมดอายุ ให้ init ใหม่
SID_FILE=/tmp/apify_sid
H=(-H "Content-Type: application/json" -H "Accept: application/json, text/event-stream" -H "Authorization: Bearer dummy")
if [ "$1" = init ]; then
  curl -s -D /tmp/apify_h.txt -o /dev/null -X POST https://mcp.apify.com/ "${H[@]}" \
    -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"client","version":"1"}}}'
  grep -i '^mcp-session-id' /tmp/apify_h.txt | awk '{print $2}' | tr -d '\r' > "$SID_FILE"
  curl -s -X POST https://mcp.apify.com/ "${H[@]}" -H "Mcp-Session-Id: $(cat $SID_FILE)" -d '{"jsonrpc":"2.0","method":"notifications/initialized"}' >/dev/null
  echo "session $(cat $SID_FILE)"; exit 0
fi
curl -s --max-time 120 -X POST https://mcp.apify.com/ "${H[@]}" -H "Mcp-Session-Id: $(cat $SID_FILE)" -H "Mcp-Protocol-Version: 2025-03-26" -d "$1" | sed -n 's/^data: //p'
# ตัวอย่างที่เคยใช้ (2026-11-20): actor streamers/youtube-scraper
#  input: {"startUrls":[{"url":"https://www.youtube.com/results?search_query=<คำไทย>&sp=EgIYAQ%253D%253D&hl=th&gl=TH"}],"maxResults":15,"maxResultsShorts":15}
#  ถอดสูตรคลิป: {"startUrls":[{"url":"https://www.youtube.com/shorts/<id>"}],"aiVideoDescription":true,"transcriptionAndSubtitle":"ALWAYS_SUBTITLES","subtitlesLanguage":"any"}
#  ใส่ "async":true ใน arguments ของ call-actor แล้ววน get-actor-run {"runId":..,"waitSecs":45} จน SUCCEEDED แล้ว get-dataset-items
#  ราคา ~$0.004/คลิป, AI description ~$0.015/นาที
