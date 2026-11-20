<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#140B2E}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.card .vid,.pin .vid,.bcat .vid{width:100%;height:100%}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(20,11,46,0) 55%,rgba(20,11,46,.5) 100%)}
.dbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 38%,#4A2490 0%,#2A1660 45%,#140B2E 100%)}
.sbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 34%,#2B1420 0%,#120C18 50%,#05050A 100%)}
.stars{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
/* card on its own blurred backdrop (720p sources / stills: never blown up full screen) */
.bgb{position:absolute;left:-60px;top:-100px;width:1200px;height:2120px;object-fit:cover;transform-origin:50% 45%}
.card{position:absolute;border-radius:30px;overflow:hidden;background:#000;box-shadow:0 0 0 8px #FFF8EE,0 0 0 15px #10080A,0 34px 70px rgba(0,0,0,.55)}
.card img{position:absolute;left:0;top:0;width:100%;height:100%;object-fit:cover}
/* split screen "ยุคนี้ | Gen Z" */
.halfL{position:absolute;left:0;top:0;width:540px;height:1920px;background:linear-gradient(160deg,#7A4A22 0%,#3E2414 60%,#1E120A 100%)}
.halfR{position:absolute;left:540px;top:0;width:540px;height:1920px;background:linear-gradient(200deg,#5B1FA8 0%,#26105A 55%,#0E0826 100%)}
.seam{position:absolute;left:532px;top:0;width:16px;height:1920px;background:linear-gradient(#FFE14D,#FF6FAE,#3DDC84)}
.pan{position:absolute;top:440px;width:386px;height:640px;border-radius:34px;overflow:hidden;background:#1B1030;
  box-shadow:0 0 0 7px #FFF8EE,0 0 0 14px #10080A,0 24px 50px rgba(0,0,0,.5)}
.pl{left:84px}.pr{left:504px}
.pin{position:absolute;left:0;top:0;width:386px;height:640px}
.pin img{position:absolute;left:0;top:0;width:100%;height:100%;object-fit:cover}
.ph{position:absolute;left:0;top:0;width:386px;height:640px;display:flex;align-items:center;justify-content:center;
  border:6px dashed rgba(255,255,255,.35);border-radius:34px;color:rgba(255,255,255,.5);font-weight:900;font-size:200px}
.fl{position:absolute;left:0;top:0;width:386px;height:640px;background:#fff;opacity:0}
.hw{position:absolute;top:345px;width:386px;height:84px;text-align:center}
.hdr{display:inline-flex;align-items:center;gap:12px;height:84px;padding:0 30px 0 22px;border-radius:42px;border:7px solid #10080A;
  font-weight:900;font-size:54px;color:#10080A;white-space:nowrap;box-shadow:0 8px 0 rgba(0,0,0,.4)}
.hdr svg{width:50px;height:50px}
.hwarm{background:#F4B860}.hneon{background:#3DDC84;color:#10080A}
/* chat bubbles in the panels */
.bub{position:absolute;background:#fff;border:7px solid #10080A;border-radius:34px;padding:12px;box-shadow:0 12px 0 rgba(0,0,0,.35);opacity:0}
.bub img{display:block;border-radius:22px}
.bub .bt{margin-top:6px;text-align:center;font-weight:900;font-size:46px;line-height:1.1;color:#C2186B;white-space:nowrap}
.bub .tail{position:absolute;bottom:-30px;width:44px;height:44px;background:#fff;border-right:7px solid #10080A;border-bottom:7px solid #10080A}
.bcat{position:relative;width:300px;height:353px;border-radius:22px;overflow:hidden}
.tag{position:absolute;left:0;top:0;display:flex;align-items:center;gap:10px;height:76px;padding:0 26px 0 18px;border-radius:38px;border:6px solid #10080A;
  font-weight:900;font-size:44px;color:#10080A;white-space:nowrap;opacity:0;box-shadow:0 8px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.tag svg{width:46px;height:46px}
/* hook title */
#tshade{position:absolute;left:0;top:0;width:1080px;height:900px;background:linear-gradient(rgba(14,8,32,.8) 0%,rgba(14,8,32,.55) 60%,rgba(14,8,32,0) 100%)}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:22px #10080A;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 10px 0 rgba(0,0,0,.45)}
#title .k{color:#fff}
/* year chip (one element: corner -> centre -> corner) */
#yr{position:absolute;left:0;top:0;height:80px;padding:0 26px 0 16px;border-radius:40px;border:7px solid #10080A;background:#FFE14D;opacity:0;
  display:flex;align-items:center;gap:10px;font-weight:900;font-size:54px;color:#10080A;white-space:nowrap;box-shadow:0 8px 0 rgba(0,0,0,.4);transform-origin:50% 50%}
#yr svg{width:48px;height:48px}
/* morphing pill */
.pill{position:absolute;left:0;top:0;height:96px;border-radius:48px;border:7px solid #10080A;opacity:0;white-space:nowrap;
  box-shadow:0 10px 0 rgba(0,0,0,.35);transform-origin:50% 50%}
.pill .tx{position:absolute;top:50%;left:96px;transform:translateY(-54%);font-weight:900;font-size:50px;white-space:nowrap;color:#10080A}
.pill .bd{position:absolute;left:12px;top:9px;width:64px;height:64px;border-radius:32px;background:#10080A}
.pill .bd svg{width:44px;height:44px;color:#fff;position:absolute;left:10px;top:10px}
.ic{overflow:visible}
#meas{position:absolute;left:-3000px;top:0;font-weight:900;font-size:50px;white-space:nowrap;visibility:hidden}
/* big number (one element, several states) */
#big{position:absolute;left:0;top:470px;width:1080px;text-align:center;opacity:0;transform-origin:50% 40%}
#big .pre{font-weight:900;font-size:64px;line-height:1.1;color:#fff;-webkit-text-stroke:14px #10080A;paint-order:stroke fill;white-space:nowrap}
#big .row{white-space:nowrap;line-height:1}
#big .n{font-weight:900;font-size:220px;color:#FFE14D;-webkit-text-stroke:24px #10080A;paint-order:stroke fill;text-shadow:0 12px 0 rgba(0,0,0,.45)}
#big .u{font-weight:900;font-size:96px;color:#fff;-webkit-text-stroke:16px #10080A;paint-order:stroke fill;margin-left:14px}
#btag{position:absolute;left:0;top:0;display:flex;align-items:center;gap:12px;height:72px;padding:0 26px 0 18px;border-radius:36px;
  background:#FFF8EE;border:6px solid #10080A;font-weight:700;font-size:40px;color:#10080A;white-space:nowrap;opacity:0;transform-origin:50% 50%}
#btag svg{width:44px;height:44px;color:#12894A}
/* timeline labels, doc card, donut, ear, slider, comment bubble */
.tlab{position:absolute;left:0;top:0;width:300px;text-align:center;font-weight:900;font-size:96px;color:#fff;-webkit-text-stroke:18px #10080A;paint-order:stroke fill;opacity:0}
#pew{position:absolute;left:0;top:930px;width:1080px;text-align:center;font-weight:700;font-size:40px;color:rgba(255,255,255,.88);opacity:0}
#doc{position:absolute;left:250px;top:480px;width:580px;height:440px;border-radius:36px;background:#FFF8EE;box-shadow:0 0 0 8px #10080A,0 30px 60px rgba(0,0,0,.5);opacity:0;transform-origin:50% 50%}
#doc .di{position:absolute;left:44px;top:44px;width:110px;height:110px;color:#3B2D99}
#doc .dt{position:absolute;left:176px;top:46px;font-weight:900;font-size:50px;color:#10080A;white-space:nowrap}
#doc .ds{position:absolute;left:178px;top:112px;font-weight:700;font-size:36px;color:#6B5B7B}
#doc .sk{position:absolute;left:46px;height:24px;border-radius:12px;background:#E3DCEB}
#globe{position:absolute;left:700px;top:400px;width:160px;height:160px;border-radius:80px;background:#6FA8FF;border:8px solid #10080A;opacity:0;color:#10080A}
#globe svg{position:absolute;left:22px;top:22px;width:100px;height:100px}
#donut{position:absolute;left:0;top:0;width:1080px;height:1100px;opacity:0}
#dlab{position:absolute;left:0;top:930px;width:1080px;text-align:center;font-weight:900;font-size:64px;color:#fff;-webkit-text-stroke:14px #10080A;paint-order:stroke fill;white-space:nowrap}
#ear{position:absolute;left:390px;top:490px;width:300px;height:300px;border-radius:150px;background:#2A1E33;border:8px solid #FFF8EE;opacity:0;color:#FFF8EE}
#ear svg{position:absolute;left:50px;top:50px;width:184px;height:184px}
.stx{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;white-space:nowrap;opacity:0;-webkit-text-stroke:20px #10080A;paint-order:stroke fill}
#slider{position:absolute;left:150px;top:500px;width:740px;height:150px;border-radius:40px;background:rgba(16,8,10,.72);border:6px solid #FFF8EE;opacity:0}
#slider svg.vi{position:absolute;left:34px;top:35px;width:68px;height:68px;color:#fff}
#strk{position:absolute;left:140px;top:61px;width:540px;height:20px;border-radius:10px;background:rgba(255,255,255,.25)}
#sfil{position:absolute;left:140px;top:61px;width:0;height:20px;border-radius:10px;background:#3DDC84}
#sknob{position:absolute;left:0;top:36px;width:70px;height:70px;border-radius:35px;background:#fff;border:6px solid #10080A}
#note{position:absolute;left:120px;top:1340px;width:780px;text-align:center;color:#fff;font-weight:700;font-size:40px;opacity:0;
  -webkit-text-stroke:10px #10080A;paint-order:stroke fill}
#cbub{position:absolute;left:130px;top:390px;width:760px;height:430px;border-radius:50px;background:#FFF8EE;border:8px solid #10080A;opacity:0;
  box-shadow:0 14px 0 rgba(0,0,0,.4);text-align:center;transform-origin:30% 100%}
#cbub .ct{position:absolute;left:70px;bottom:-46px;width:70px;height:70px;background:#FFF8EE;border-right:8px solid #10080A;border-bottom:8px solid #10080A;transform:rotate(45deg)}
#cbub .q1{margin-top:44px;font-weight:900;font-size:84px;line-height:1.1;color:#10080A}
#cbub .q2{display:inline-block;margin-top:6px;font-weight:900;font-size:80px;line-height:1.15;color:#10080A;padding:0 20px;border-radius:20px;white-space:nowrap}
#cbub .q3{margin-top:12px;font-weight:700;font-size:46px;color:#B0306F;display:flex;align-items:center;justify-content:center;gap:12px;white-space:nowrap}
#cbub .q3 svg{width:50px;height:50px}
#gbars{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:40;pointer-events:none}
#gbars div{position:absolute;left:60px;width:840px;opacity:0;mix-blend-mode:screen}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
/* captions: centred on X 510 (safe band X 120-900), text box ~Y 1130-1245 */
.cap{position:absolute;left:10px;width:1000px;top:1190px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-52px;display:block;color:#fff;font-weight:700;line-height:1.18;white-space:nowrap;
  -webkit-text-stroke:17px #000;paint-order:stroke fill;transform-origin:50% 80%}
.cap em{font-style:normal;color:#FFE14D}
</style></head><body>
<div id="root" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">
<svg width="0" height="0" style="position:absolute" aria-hidden="true"><defs>
%%ICONS%%
<filter id="rgbx" x="-10%" y="-10%" width="120%" height="120%" color-interpolation-filters="sRGB">
  <feColorMatrix in="SourceGraphic" type="matrix" values="1 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 1 0" result="r"/>
  <feOffset id="rgbR" in="r" dx="0" dy="0" result="ro"/>
  <feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 0  0 1 0 0 0  0 0 0 0 0  0 0 0 1 0" result="g"/>
  <feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 0  0 0 0 0 0  0 0 1 0 0  0 0 0 1 0" result="b"/>
  <feOffset id="rgbB" in="b" dx="0" dy="0" result="bo"/>
  <feBlend in="ro" in2="g" mode="screen" result="rg"/><feBlend in="rg" in2="bo" mode="screen"/>
</filter></defs></svg>

<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-s01"><img class="bgb" id="bg-s01" src="assets/hook-bg.jpg" alt=""/><div class="card" id="cd-s01" style="left:190px;top:740px;width:700px;height:930px">%%V_HOOK%%</div></div>
  <div class="sc" id="sh-s02"><img class="bgb" id="bg-s02" src="assets/grin-bg.jpg" alt=""/><div class="card" id="cd-s02" style="left:190px;top:680px;width:700px;height:930px"><img src="assets/grin.jpg" alt=""/></div>
    <div class="tag" id="gzs" style="background:#3DDC84"><svg class="ic"><use href="#ic-sparkles"/></svg>Gen Z</div></div>
  <div class="sc" id="sh-s03"><img class="bgb" id="bg-s03" src="assets/dance-bg.jpg" alt=""/>
    <div class="kb" id="kb-s03"><svg class="ov" viewBox="0 0 1080 1920"><rect x="236" y="640" width="608" height="820" rx="70" fill="#15121F" stroke="#10080A" stroke-width="10"/>
      <rect x="470" y="656" width="140" height="22" rx="11" fill="#2C2838"/></svg>
      <div class="card" id="cd-s03" style="left:270px;top:690px;width:540px;height:717px;box-shadow:none;border-radius:40px">%%V_TIKGR%%</div></div></div>
  <div class="sc" id="sh-s04"><div class="kb" id="kb-s04">%%V_SELFIE%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-g1"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-sp1"><div class="halfL"></div><div class="halfR"></div><div class="seam"></div>
    <div class="hw" id="hL1" style="left:84px"><span class="hdr hwarm"><svg class="ic"><use href="#ic-sun"/></svg>ยุคนี้</span></div>
    <div class="hw" id="hR1" style="left:504px"><span class="hdr hneon"><svg class="ic"><use href="#ic-zap"/></svg>Gen Z</span></div>
    <div class="pan pl" id="pL1"><div class="pin" id="iL1"><img src="assets/hands.jpg" alt=""/>%%V_POPPY%%</div></div>
    <div class="pan pr" id="pR1"><div class="ph">?</div><div class="pin" id="iR1">%%V_PHONEG%%</div><div class="fl" id="fR1"></div></div>
    <div class="bub" id="bubF" style="left:100px;top:700px"><img src="assets/flowers.jpg" width="340" height="255" alt=""/><div class="bt">สวัสดีวันจันทร์</div><div class="tail" style="left:40px;transform:rotate(45deg)"></div></div>
    <div class="bub" id="bubC" style="left:528px;top:690px"><div class="bcat">%%V_CAT%%</div><div class="tail" style="right:40px;transform:rotate(45deg)"></div></div>
    <div class="tag" id="tagL" style="background:#FF6FAE"><svg class="ic"><use href="#ic-cat"/></svg>แทนรูปหลาน</div></div>
  <div class="sc" id="sh-s12"><img class="bgb" id="bg-s12" src="assets/baby-bg.jpg" alt=""/><div class="card" id="cd-s12" style="left:190px;top:680px;width:700px;height:930px">%%V_BABY%%</div></div>
  <div class="sc" id="sh-g2"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-sp2"><div class="halfL"></div><div class="halfR"></div><div class="seam"></div>
    <div class="hw" id="hL2" style="left:84px"><span class="hdr hwarm"><svg class="ic"><use href="#ic-sun"/></svg>ยุคนี้</span></div>
    <div class="hw" id="hR2" style="left:504px"><span class="hdr hneon"><svg class="ic"><use href="#ic-zap"/></svg>Gen Z</span></div>
    <div class="pan pl" id="pL2"><div class="pin" id="iL2">%%V_RADIO%%</div></div>
    <div class="pan pr" id="pR2"><div class="ph">?</div><div class="pin" id="iR2">%%V_HPGIRL%%%%V_HPGMA%%</div><div class="fl" id="fR2"></div></div>
    <svg class="ov" id="notes" viewBox="0 0 1080 1920"></svg>
    <div class="stx" id="haT" style="top:730px;left:0px;font-size:200px;color:#FFE14D;-webkit-text-stroke:26px #10080A">หา?</div>
    <div class="stx" id="araiT" style="top:950px;left:0px;font-size:72px;color:#fff;-webkit-text-stroke:16px #10080A">อะไรนะ</div></div>
  <div class="sc" id="sh-g3"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-s19"><img class="bgb" id="bg-s19" src="assets/phones-bg.jpg" alt=""/><div class="card" id="cd-s19" style="left:190px;top:680px;width:700px;height:930px">%%V_PHONES%%</div></div>
  <div class="sc" id="sh-sp3"><div class="halfL"></div><div class="halfR"></div><div class="seam"></div>
    <div class="hw" id="hL3" style="left:84px"><span class="hdr hwarm"><svg class="ic"><use href="#ic-sun"/></svg>ยุคนี้</span></div>
    <div class="hw" id="hR3" style="left:504px"><span class="hdr hneon"><svg class="ic"><use href="#ic-zap"/></svg>Gen Z</span></div>
    <div class="pan pl" id="pL3"><div class="pin" id="iL3"><img src="assets/specs.jpg" alt=""/></div></div>
    <div class="pan pr" id="pR3"><div class="ph">?</div><div class="pin" id="iR3"><img src="assets/gzw1.jpg" alt=""/><img id="gzw2" src="assets/gzw2.jpg" alt="" style="opacity:0"/></div><div class="fl" id="fR3"></div></div>
    <div class="tag" id="tagB" style="background:#F4B860"><svg class="ic"><use href="#ic-book-open"/></svg>แค่ตอนอ่าน</div>
    <div class="tag" id="tagD" style="background:#3DDC84"><svg class="ic" id="tagDic"><use href="#ic-clock"/></svg>ทั้งวัน</div></div>
  <div class="sc" id="sh-g4"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-g5"><div class="sbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-s26"><div class="kb" id="kb-s26">%%V_BUDS%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-s26b"><div class="kb" id="kb-s26b">%%V_BUDS2%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-g6"><div class="sbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-s28"><img class="bgb" id="bg-s28" src="assets/couple-bg.jpg" alt=""/><div class="card" id="cd-s28" style="left:110px;top:480px;width:860px;height:645px"><img src="assets/couple.jpg" alt=""/>
    <div id="mgL" style="position:absolute;left:0;top:0;width:430px;height:645px;background:#E8902E;mix-blend-mode:color"></div>
    <div id="mgR" style="position:absolute;left:430px;top:0;width:430px;height:645px;background:#9B3DFF;mix-blend-mode:color"></div></div></div>
  <div class="sc" id="sh-g7"><div class="dbg"></div><svg class="stars" viewBox="0 0 1080 1920"></svg></div>
  <div class="sc" id="sh-s29"><img class="bgb" id="bg-s29" src="assets/hook-bg.jpg" alt=""/><div class="card" id="cd-s29" style="left:190px;top:740px;width:700px;height:930px">%%V_LOOP%%</div></div>
</div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <svg class="ov" id="gsvg" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="glayer"></g></svg>
  <div class="tlab" id="lab97">1997</div><div class="tlab" id="lab12">2012</div>
  <div id="pew">นิยามตาม Pew Research Center</div>
  <div id="big"><div class="pre" id="bpre"></div><div class="row"><span class="n" id="bn"></span><span class="u" id="bu"></span></div></div>
  <div id="btag"><svg class="ic"><use id="btagUse" href="#ic-circle-check"/></svg><span id="btagT"></span></div>
  <div class="tag" id="age" style="background:#FFE14D"><svg class="ic"><use href="#ic-users"/></svg>อายุ 12-35</div>
  <div id="doc"><svg class="ic di"><use href="#ic-file-text"/></svg><div class="dt">Holden et al.</div><div class="ds">Ophthalmology · 2016</div>
    <div class="sk" style="top:210px;width:480px"></div><div class="sk" style="top:256px;width:420px"></div><div class="sk" style="top:302px;width:460px"></div><div class="sk" style="top:348px;width:300px"></div></div>
  <div id="globe"><svg class="ic"><use href="#ic-globe"/></svg></div>
  <div id="donut"><svg width="1080" height="1100" viewBox="0 0 1080 1100">
    <circle cx="540" cy="700" r="190" fill="none" stroke="#10080A" stroke-width="86"/>
    <circle cx="540" cy="700" r="190" fill="none" stroke="rgba(255,255,255,.18)" stroke-width="66"/>
    <circle id="darc" cx="540" cy="700" r="190" fill="none" stroke="#3DDC84" stroke-width="66" stroke-dasharray="0 1194" transform="rotate(-90 540 700)"/>
    <text id="dpct" x="540" y="738" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="110" fill="#fff" stroke="#10080A" stroke-width="16" paint-order="stroke">~50%</text>
    <g id="deye" opacity="0"><circle cx="760" cy="520" r="62" fill="#FFE14D" stroke="#10080A" stroke-width="8"/><use href="#ic-eye" x="722" y="482" width="76" height="76" color="#10080A"/></g>
    </svg><div id="dlab">ราวครึ่งโลกสายตาสั้น</div></div>
  <div class="stx" id="taeT" style="top:300px;font-size:130px;color:#fff">แต่เรื่องหู</div>
  <div class="tag" id="triam" style="background:#FFE14D;font-size:52px;height:90px"><svg class="ic"><use href="#ic-clock"/></svg>เตรียมได้ตั้งแต่ตอนนี้</div>
  <div id="ear"><svg class="ic"><use href="#ic-ear"/></svg></div>
  <div class="stx" id="thaworn" style="top:250px;font-size:170px;color:#FF5C6C">ถาวร</div>
  <div class="tag" id="prot" style="background:#3DDC84;font-size:56px;height:96px"><svg class="ic"><use href="#ic-shield-check"/></svg>แต่ป้องกันได้</div>
  <div class="stx" id="whoS" style="top:1010px;font-size:40px;color:rgba(255,255,255,.85);-webkit-text-stroke:0;font-weight:700">ข้อมูล: WHO</div>
  <div id="slider"><svg class="ic vi"><use id="volUse" href="#ic-volume-2"/></svg><div id="strk"></div><div id="sfil"></div><div id="sknob"></div></div>
  <div class="tag" id="chYA" style="background:#F4B860">ยุคนี้</div><div class="tag" id="chYB" style="background:#3DDC84">Gen Z</div>
  <div id="cbub"><div class="q1">ตอนแก่</div><div class="q2" id="q2">อยากเป็นแบบไหน?</div>
    <div class="q3" id="q3"><svg class="ic"><use href="#ic-message-circle"/></svg>เมนต์บอกหน่อย</div><div class="ct"></div></div>
  <div class="tag" id="choA" style="background:#F4B860;font-size:50px;height:90px"><svg class="ic"><use href="#ic-sun"/></svg>แบบยุคนี้</div>
  <div class="tag" id="choB" style="background:#3DDC84;font-size:50px;height:90px"><svg class="ic"><use href="#ic-zap"/></svg>แบบ Gen Z</div>
  <div class="pill" id="pill"><div class="bd" id="pillBd"><svg class="ic" id="pillIc"><use id="pillUse" href="#ic-users"/></svg></div>
    <span class="tx" id="pillA"></span><span class="tx" id="pillB"></span></div>
  <div id="note">หูอื้อ หรือได้ยินแย่ลงบ่อย ปรึกษาแพทย์</div>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1" style="color:#FFE14D">ปี 2070...</div><div class="tl" id="tl2">ยาย <span class="k" id="kGz">Gen Z</span> อาจจะ</div>
    <div class="tl" id="tl3">กำลังเต้น <span class="k" id="kTt">TikTok</span></div><div class="tl" id="tl4">อยู่ก็ได้นะ</div></div>
  <div id="yr"><svg class="ic"><use href="#ic-hourglass"/></svg><span id="yrn">2026</span></div>
  <div id="meas"></div>
</div>
</div>
<div id="gbars"><div id="gb0"></div><div id="gb1"></div><div id="gb2"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-b69493a8.mp3"></audio>
</div>

<script>
/* Motion engine from templates/brainrot-v2 (closed-form springs, motion-broll). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). One year chip travels corner -> centre -> corner,
   one pill morphs label to label, one big-number element carries every figure. Everything is a function of t. */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
const T={},H={}; for(const k in SH){T[k]=SH[k].start; if(SH[k].hit!=null)H[k]=SH[k].hit;}
const NS='http://www.w3.org/2000/svg';

// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],POP=[22,0.5],OUT=[30,1];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);return `rgb(${x.map((v,i)=>Math.round(lerp(v,y[i],clamp(u)))).join(',')})`;};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const f2=v=>v.toFixed(2);
const win=(t,a,b,sp=POP)=>{if(t<a||t>=b+0.1)return 0; const i=S(t-a,sp[0],sp[1]); const o=t>b?1-clamp((t-b)/0.08):1; return Math.max(0,i)*o;};
const pinO=(t,a,b)=>(t<a||t>=b+0.1)?0:clamp((t-a)/0.06)*(t>b?1-clamp((t-b)/0.08):1);
const meas=$('meas'); const wcache={};
const tw=txt=>{if(wcache[txt])return wcache[txt]; meas.textContent=txt; const w=meas.offsetWidth;
  if(document.fonts&&document.fonts.status==='loaded'&&w>0)wcache[txt]=w; return w||txt.length*28;};
const PINK='#FF6FAE',YEL='#FFE14D',GRN='#3DDC84',ORG='#FFA53D',RED='#FF4D5E',BLU='#6FA8FF',INK='#10080A';
const G=$('glayer');
const sc1=v=>Math.max(0.001,v).toFixed(4);
// a tag (div) centred at x,y popping in [a,b)
const tagAt=(id,t,a,b,x,y,rot=-2,sp=BOUNCE)=>{const e=$(id), v=win(t,a,b,sp); if(!show(e,clamp(v*2)))return 0;
  const w=e.offsetWidth||300, h=e.offsetHeight||76;
  e.style.transform=`translate(${f2(x-w/2)}px,${f2(y-h/2+4*Math.sin(t*2.6+x))}px) rotate(${f2(rot+1.2*Math.sin(t*2.1))}deg) scale(${sc1(v)})`; return v;};

// ---------- scenes ----------
// entries: cut (hard) | whip (0.12 s push) | zoom (zoom punch-in, 0.1 s fade) | match (0.1 s crossfade)
// kb = element pushed in (card or full plate), bg = blurred backdrop (counter-drift = parallax)
const SC=[
 {id:'sh-s01',a:0,kb:'cd-s01',bg:'bg-s01',s0:1.0,s1:1.06,org:'50% 35%',in:'none',still:1},
 {id:'sh-s02',a:T.s02,kb:'cd-s02',bg:'bg-s02',s0:1.02,s1:1.14,r0:-1.2,r1:1.0,org:'40% 25%',in:'whip'},
 {id:'sh-s03',a:T.s03,kb:'kb-s03',bg:'bg-s03',s0:1.0,s1:1.08,r0:1.0,r1:-1.0,org:'50% 55%',in:'zoom'},
 {id:'sh-s04',a:T.s04,kb:'kb-s04',s0:1.03,s1:1.1,r0:0.6,r1:-0.6,org:'55% 30%',in:'cut'},
 {id:'sh-g1',a:T.s05,in:'zoom'},
 {id:'sh-sp1',a:T.s07,in:'whip'},
 {id:'sh-s12',a:T.s12,kb:'cd-s12',bg:'bg-s12',s0:1.02,s1:1.12,r0:-1,r1:1,org:'50% 50%',in:'zoom'},
 {id:'sh-g2',a:T.s12b,in:'match'},
 {id:'sh-sp2',a:T.s14,in:'whip'},
 {id:'sh-g3',a:T.s18,in:'zoom'},
 {id:'sh-s19',a:T.s19,kb:'cd-s19',bg:'bg-s19',s0:1.02,s1:1.12,r0:1,r1:-1,org:'40% 70%',in:'cut'},
 {id:'sh-sp3',a:T.s20,in:'whip'},
 {id:'sh-g4',a:T.s23,in:'zoom'},
 {id:'sh-g5',a:T.s25,in:'cut'},
 {id:'sh-s26',a:T.s26,kb:'kb-s26',s0:1.02,s1:1.09,r0:-0.5,r1:0.5,org:'50% 45%',in:'match'},
 {id:'sh-s26b',a:T.s26b,kb:'kb-s26b',s0:1.0,s1:1.1,r0:0.4,r1:-0.4,org:'50% 45%',in:'cut'},
 {id:'sh-g6',a:T.s27,in:'zoom'},
 {id:'sh-s28',a:T.s28,kb:'cd-s28',bg:'bg-s28',s0:1.0,s1:1.07,r0:-0.8,r1:0.6,org:'50% 40%',in:'whip'},
 {id:'sh-g7',a:T.s28b,in:'zoom'},
 {id:'sh-s29',a:T.s29,kb:'cd-s29',bg:'bg-s29',s0:1.06,s1:1.0,org:'50% 35%',in:'match',still:1},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1); if(s.kb)$(s.kb).style.transformOrigin=s.org;});
const XF=0.12;
function sceneState(s,t){
  if(t<s.a)return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,tx=0,sc=1;
  if(s.in==='whip'){ tx=1080*(1-eo(u/XF)); }
  else if(s.in==='zoom'){ o=eio(u/0.1); sc=1+0.3*(1-S(u,18,0.9)); }
  else if(s.in==='match'){ o=eio(u/0.1); }
  if(nx){
    if(nx.in==='whip'){ if(t>=end+XF)return null; if(t>=end) tx=-1080*eo((t-end)/XF); }
    else if(nx.in==='cut'){ if(t>=end)return null; }
    else { if(t>=end+XF)return null; if(nx.in==='zoom'&&t>end-0.1) sc*=1+0.5*ei((t-end+0.1)/0.22); }
  }
  return {o,tx,sc};
}
function scenes(t){
  SC.forEach(s=>{const r=sceneState(s,t), e=$(s.id);
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`translateX(${f2(r.tx)}px) scale(${r.sc.toFixed(4)})`;
    if(!s.kb)return;
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    const k=lerp(s.s0,s.s1,s.still?uu:eio(0.1+0.9*uu));
    if(s.bg)$(s.bg).style.transform=`scale(${(1.1+0.5*(k-1)).toFixed(5)}) translateY(${f2(s.still?0:-30*uu)}px)`;
    if(s.still){ $(s.kb).style.transform=`scale(${k.toFixed(5)})`; return; }   // hook / loop: pure push (frame 0 = last frame)
    const rr=lerp(s.r0,s.r1,uu), dx=10*Math.sin(t*1.7+s.a), dy=8*Math.cos(t*1.3+s.a);
    $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
  });
}
// stars in the graphic backdrops (deterministic), drifting + twinkling
const STARS=[]; document.querySelectorAll('.stars').forEach((sv,j)=>{for(let i=0;i<46;i++){const x=(i*233+j*97)%1080, y=(i*421+j*151)%1920, r=2+(i%4);
  STARS.push({e:el('circle',{cx:x,cy:y,r,fill:i%7?'#D9C9FF':'#3DDC84',opacity:.5},sv),x,y,i,j});}});
function stars(t){STARS.forEach(s=>{s.e.setAttribute('cy',f2(((s.y-t*(30+s.i%5*12))%1920+1920)%1920)); s.e.setAttribute('opacity',f2(0.25+0.45*(0.5+0.5*Math.sin(t*3+s.i))));});}

// ---------- zoom punches + glitch (registry zoom-through / rgb-glitch-text, adapted) ----------
const PUNCH=[K.y2070,T.s06,K.ha,K.mai];
const SUB=[T.s05b,T.s06b,T.s08,T.s08b,T.s09,T.s10,T.s13,T.s13b,T.s15,T.s16,T.s17,T.s18b,T.s20b,T.s21,T.s22,T.s23b,T.s23c,T.s24];
const GL=[T.s25], GLD=0.134; // 4 frames
const GOFF=[[10,-8,-14],[-8,10,-6],[12,-6,-16],[-6,6,-8]];
function fx(t){
  let p=0; PUNCH.forEach(a=>{const u=t-a; if(u>=0&&u<0.8)p+=0.085*Math.exp(-u*7)*Math.cos(u*13);});
  SUB.forEach(a=>{const u=t-a; if(u>=0&&u<0.6)p+=0.035*Math.exp(-u*9)*Math.cos(u*14);});
  let gi=-1; GL.forEach(a=>{if(t>=a&&t<a+GLD)gi=Math.floor((t-a)*30);});
  const st=$('stage');
  if(gi>=0){const o=GOFF[gi%4]; $('rgbR').setAttribute('dx',o[0]); $('rgbB').setAttribute('dx',o[1]); st.style.filter='url(#rgbx)';
    st.style.transform=`translateX(${o[2]}px) scale(${(1+p).toFixed(4)})`;}
  else { st.style.filter='none'; st.style.transform=`scale(${(1+p).toFixed(4)})`; }
  ['gb0','gb1','gb2'].forEach((id,i)=>{const b=$(id); if(gi<0){b.style.opacity='0';return;}
    const y=[(300+gi*410)%1500,(820+gi*290)%1500,(560+gi*530)%1500][i]+120, h=[26,60,14][i];
    b.style.top=y+'px'; b.style.height=h+'px'; b.style.background=['#22d3ee','#ef4444','#FFFFFF'][i]; b.style.opacity=['.55','.45','.6'][i];
    b.style.transform=`translateX(${(i%2?-1:1)*(20+gi*9)}px)`;});
}

// ---------- hook title: complete at frame 0 (no fade-in), breathes 1.0<->1.04, back in the last ~0.3 s (loop) ----------
const TL=[['tl1',320,104],['tl2',440,90],['tl3',538,90],['tl4',634,80]];
TL.forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
const TBACK=DUR-0.3;
function title(t){
  let o,sc;
  if(t<TBACK){ const out=eo((t-(T.s04-0.04))/0.12); o=1-out; sc=1+0.25*out; }
  else { const a=S(t-TBACK,26,0.8); o=clamp(a*1.4); sc=1+0.12*(1-a); }
  show($('title'),o); show($('tshade'),t<TBACK?o:clamp((t-T.s29)/0.4));
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9)), live=t<TBACK?1:0;
  TL.forEach(([id],i)=>{const e=$(id);
    e.style.transform=`translateY(${f2(live*3*Math.sin(t*3+i))}px) rotate(${f2(i===0?-1.5*live*Math.sin(t*2.4):0)}deg) scale(${((t<TBACK?br:1)*sc).toFixed(4)})`;});
  // karaoke: the spoken key words turn neon as they are said
  [['kGz',K.yay],['kTt',K.tiktok]].forEach(([id,a])=>{const u=t<TBACK&&t>=a?clamp((t-a)/0.12):0; const e=$(id);
    e.style.color=mix('#FFFFFF','#3DDC84',u); e.style.display='inline-block'; e.style.transform=`scale(${f2(1+0.12*Math.sin(clamp((t-a)/0.3)*Math.PI)*(t>=a&&t<TBACK?1:0))})`;});
}

// ---------- year chip: counts 2026 -> 2070 on "2070", corner -> centre ("ปีนั้น") -> corner, rolls back for the loop ----------
const yX=track(210,[[T.s06,540,MORPH],[T.s06b,540],[T.s07,210,FAST]]);
const yY=track(288,[[T.s06,560,MORPH],[T.s06b,372],[T.s07,288,FAST]]);
const yK=track(1,[[T.s06,2.3,BOUNCE],[T.s06b,1.45],[T.s07,1,FAST]]);
const yV=track(1,[[T.s12,0,OUT],[T.s14,1,POP],[T.s18,0,OUT],[T.s20,1,POP],[T.s23,0,OUT],[T.s28,1,POP]]);
function yearF(t){
  const e=$('yr'), v=yV(t); if(!show(e,clamp(v*2))){return;}
  let y=2070; if(t<K.y2070+0.05) y=Math.round(lerp(2026,2070,eio((t-0.04)/(K.y2070+0.01))));
  if(t>=TBACK) y=Math.round(lerp(2070,2026,eio((t-TBACK)/0.25)));
  $('yrn').textContent=String(y);
  const w=e.offsetWidth||230, ping=(t>=K.y2070&&t<K.y2070+0.4)?0.18*Math.exp(-(t-K.y2070)*9)*Math.cos((t-K.y2070)*16):0;
  e.style.transform=`translate(${f2(yX(t)-w/2)}px,${f2(yY(t)-40)}px) rotate(${f2(-3+1.5*Math.sin(t*2))}deg) scale(${sc1(v*(yK(t)+ping))})`;
  e.style.background=t>=TBACK?mix(YEL,'#FFF8EE',eio((t-TBACK)/0.25)):(t>=K.y2070?YEL:mix('#FFF8EE',YEL,clamp(t/K.y2070)));
}

// ---------- the pill (one element morphing) ----------
const PST=[ // [t, text, colour, icon, centre x, centre y, scale]
  [K.genz,'Gen Z',GRN,'users',540,400,1.35],
  [T.s05,'Gen Z',GRN,'users',540,560,1.35],
  [T.s06,null],
  [T.s12,'ปี 2024 (พ.ศ. 2567)',YEL,'calendar',540,420,1.2],
  [T.s12b,'เด็กไทยเกิดปี 2024 (2567)',YEL,'calendar',540,360,1.0],
  [T.s13,'ต่ำกว่า 5 แสน',ORG,'trending-down',540,360,1.3],
  [T.s14,null],
  [T.s18,'WHO · องค์การอนามัยโลก',BLU,'globe',540,370,1.0],
  [T.s19,'เสี่ยงหูเสื่อมจากเสียงดัง',ORG,'triangle-alert',540,420,1.0],
  [T.s20,null],
  [T.s23,'งานวิจัย · Holden 2016',BLU,'file-text',540,360,1.0],
  [T.s23b,'คาดการณ์',ORG,'trending-up',540,360,1.3],
  [T.s23c,'คาดการณ์ · ปี 2050',ORG,'trending-up',540,360,1.1],
  [T.s25,null],
  [T.s26,'เบาเสียงหูฟัง',GRN,'headphones',540,380,1.2],
  [T.s26b,'หูเสื่อมจากเสียงดัง',ORG,'triangle-alert',540,380,1.15],
  [T.s27,null],
  [K.tonkae,'ตอนแก่...',PINK,'hourglass',540,370,1.3],
  [T.s28b,null],
];
const pill=$('pill'),pA=$('pillA'),pB=$('pillB'),pUse=$('pillUse');
function pillF(t){
  let i=-1; for(let k=0;k<PST.length;k++) if(t>=PST[k][0]) i=k;
  if(i<0){pill.style.opacity='0';return;}
  const cur=PST[i], prv=i>0?PST[i-1]:null, u=t-cur[0];
  let txt0,txt1,col0,col1,ic0,ic1,x0,x1,y0,y1,k0,k1,s0,s1,p;
  const sh=st=>st&&st[1]!=null;
  if(sh(cur)&&sh(prv)){ p=clamp(S(u,15,0.8)); [txt0,col0,ic0,x0,y0,k0]=prv.slice(1); [txt1,col1,ic1,x1,y1,k1]=cur.slice(1); s0=1;s1=1; }
  else if(sh(cur)){ p=1; [txt1,col1,ic1,x1,y1,k1]=cur.slice(1); txt0=txt1;col0=col1;ic0=ic1;x0=x1;y0=y1;k0=k1; s0=0; s1=1; }
  else if(sh(prv)){ p=1; [txt0,col0,ic0,x0,y0,k0]=prv.slice(1); txt1=txt0;col1=col0;ic1=ic0;x1=x0;y1=y0;k1=k0; s0=1; s1=0; }
  else {pill.style.opacity='0';return;}
  let sc; if(s0===0) sc=S(u,POP[0],POP[1]); else if(s1===0) sc=1-clamp(u/0.08); else sc=1+0.08*Math.sin(clamp(p)*Math.PI);
  if(sc<0.004){pill.style.opacity='0';return;}
  const w0=tw(txt0)+136, w1=tw(txt1)+136, w=lerp(w0,w1,p), x=lerp(x0,x1,p), y=lerp(y0,y1,p);
  pill.style.opacity='1'; pill.style.width=f2(w)+'px'; pill.style.background=mix(col0,col1,p);
  pill.style.transform=`translate(${f2(x-w/2)}px,${f2(y-48)}px) rotate(${f2(-2+1.2*Math.sin(t*2.3))}deg) scale(${(Math.max(0.001,sc)*lerp(k0,k1,p)).toFixed(4)})`;
  pA.textContent=txt0; pB.textContent=txt1; pA.style.opacity=f2(1-clamp(p*2.5)); pB.style.opacity=f2(clamp(p*2.5-0.3)); if(txt0===txt1){pA.style.opacity='0';pB.style.opacity='1';}
  pUse.setAttribute('href','#ic-'+(p<0.5?ic0:ic1));
}

// ---------- s02 sticker, s03 phone UI (generic hearts / notes, no app logo) ----------
const HEARTS=[...Array(6)].map((_,i)=>el('use',{href:i%3===2?'#ic-music':'#ic-heart',x:-36,y:-36,width:72,height:72,color:i%3===2?'#7FD3FF':'#FF4D8B',opacity:0},G));
const UI=el('g',{opacity:0},G); el('circle',{cx:0,cy:0,r:20,fill:'#FF3B5C'},UI); el('text',{x:34,y:14,'font-family':'Kanit','font-weight':900,'font-size':40,fill:'#fff',stroke:INK,'stroke-width':8,'paint-order':'stroke'},UI).textContent='LIVE';
function hookExtras(t){
  tagAt('gzs',t,K.yay,T.s03,760,760,-8,POP);
  const on=t>=T.s03&&t<T.s04+0.05;
  UI.setAttribute('opacity',on?f2(clamp((t-T.s03)/0.1)*(0.6+0.4*Math.sin(t*12))):'0'); UI.setAttribute('transform','translate(320 750)');
  HEARTS.forEach((h,i)=>{if(!on){h.setAttribute('opacity','0');return;} const ph=((t-T.s03)*0.9+i/6)%1;
    h.setAttribute('opacity',f2(Math.sin(ph*Math.PI))); h.setAttribute('transform',`translate(${f2(760+30*Math.sin(t*3+i)-(i%2)*40)} ${f2(1340-560*ph)}) scale(${f2(0.7+0.5*ph)})`);});
}

// ---------- g1: Gen Z timeline 1997 -> 2012, then "2070" (year chip) and "60+" ----------
const TLN=el('g',{opacity:0},G);
el('line',{x1:190,y1:800,x2:890,y2:800,stroke:INK,'stroke-width':30,'stroke-linecap':'round'},TLN);
const tlBase=el('line',{x1:190,y1:800,x2:190,y2:800,stroke:'#FFF8EE','stroke-width':16,'stroke-linecap':'round'},TLN);
const tlFill=el('line',{x1:220,y1:800,x2:220,y2:800,stroke:GRN,'stroke-width':30,'stroke-linecap':'round'},TLN);
const PULSE=[0,1,2].map(()=>el('circle',{cx:220,cy:800,r:0,fill:'#FFFFFF',opacity:0},TLN));
const nA=el('circle',{cx:220,cy:800,r:0,fill:YEL,stroke:INK,'stroke-width':9},TLN), nB=el('circle',{cx:860,cy:800,r:0,fill:YEL,stroke:INK,'stroke-width':9},TLN);
function timelineF(t){
  const v=win(t,T.s05,T.s06+0.3,FAST), out=t>=T.s06?eo((t-T.s06)/0.3):0;
  TLN.setAttribute('opacity',f2(clamp(v*2)*(1-out))); TLN.setAttribute('transform',`translate(540 ${f2(800+260*out+12*Math.sin(t*2.4))}) rotate(${f2(1.5*Math.sin(t*1.7))}) scale(${f2((1-0.4*out)*(1+0.03*Math.sin(t*3.1)))}) translate(-540 -800)`);
  tlBase.setAttribute('x2',f2(lerp(190,890,clamp(S(t-T.s05,8,0.95)))));
  const a=t>=K.y1997?S(t-K.y1997,POP[0],POP[1]):0, b=t>=K.y2012?S(t-K.y2012,POP[0],POP[1]):0;
  nA.setAttribute('r',f2(Math.max(0,34*a))); nB.setAttribute('r',f2(Math.max(0,34*b)));
  tlFill.setAttribute('x2',f2(lerp(220,860,clamp(t>=K.y1997+0.2?S(t-K.y1997-0.2,3.2,1):0)*(t<K.y2012?0.85:1)+(t>=K.y2012?0:0))));
  if(t>=K.y2012) tlFill.setAttribute('x2',f2(lerp(lerp(220,860,0.85*clamp(S(K.y2012-K.y1997-0.2,3.2,1))),860,clamp(S(t-K.y2012,14,0.85)))));
  [['lab97',a,220],['lab12',b,860]].forEach(([id,s,x])=>{const e=$(id); if(!show(e,clamp(s*2)*(1-out)))return;
    e.style.transform=`translate(${f2(x-150)}px,${f2(640+20*(1-clamp(s)))}px) scale(${sc1(s)}) rotate(${f2(-3*Math.sin(t*2+x))}deg)`;});
  const fx2=+tlFill.getAttribute('x2')||220;
  PULSE.forEach((c,i)=>{const on=t>=K.y1997+0.2&&fx2>240; const ph=((t*1.3)+i/3)%1; c.setAttribute('cx',f2(lerp(220,fx2,ph))); c.setAttribute('r',f2(on?14+6*Math.sin(ph*Math.PI):0)); c.setAttribute('opacity',on?f2(Math.sin(ph*Math.PI)):'0');});
  show($('pew'),pinO(t,K.y2012+0.25,T.s06)*0.95);
}

// ---------- big number (one element): 60+ / 462,240 / ~80 / 1,000 / 2050 ----------
const fmt=n=>String(n).replace(/\B(?=(\d{3})+(?!\d))/g,',');
const BIG=[ // [from, to, word, pre, num(t), unit, tag, tagIcon, colour]
  [T.s06b,T.s07,K.hok,'',()=> '60+','ปี','คำนวณจากปีเกิด','calculator',YEL],
  [T.s12b,T.s13,K.dek,'',t=>{const u=t-K.dek; return fmt(u>=0.95?462240:Math.round(462240*clamp(S(u,6.5,1))));},'คน','ทะเบียนราษฎร์','circle-check',YEL],
  [T.s13b,T.s14,K.paet,'ครั้งแรกในรอบ',()=> '~80','ปี','','',YEL],
  [T.s18b,T.s19,K.phan,'กว่า',t=>{const u=t-K.phan; return fmt(u>=0.6?1000:Math.round(1000*clamp(S(u,10,1))));},'ล้านคน','อายุ 12-35 · เสี่ยง · WHO','circle-check',GRN],
  [T.s23b,T.s23c,K.y2050,'ปี',()=> '2050','','','',ORG],
];
function bigF(t){
  const e=$('big'), tg=$('btag'); let st=null; BIG.forEach(b=>{if(t>=b[0]&&t<b[1]+0.1)st=b;});
  if(!st){e.style.opacity='0'; tg.style.opacity='0'; return;}
  const [a,b,w,pre,num,unit,tag,tic,col]=st, v=win(t,a,b,BOUNCE);
  $('bpre').textContent=pre; $('bpre').style.display=pre?'block':'none'; $('bn').textContent=num(t); $('bu').textContent=unit; $('bn').style.color=col;
  const land=(t>=w&&t<w+1.2)?0.06*Math.exp(-(t-w-0.9)*6)*(t>w+0.9?1:0):0;
  show(e,clamp(v*2)); e.style.top=(pre?500:560)+'px';
  e.style.transform=`translateY(${f2(30*(1-clamp(v))+6*Math.sin(t*2))}px) scale(${sc1(v*(1+land))}) rotate(${f2(-1.5*Math.sin(t*1.7))}deg)`;
  if(!tag){tg.style.opacity='0';return;}
  $('btagT').textContent=tag; $('btagUse').setAttribute('href','#ic-'+tic);
  const vt=win(t,a+0.25,b,POP); if(!show(tg,clamp(vt*2)))return; const tw2=tg.offsetWidth||420;
  tg.style.transform=`translate(${f2(540-tw2/2)}px,${f2(900+4*Math.sin(t*3))}px) scale(${sc1(vt)})`;
}

// ---------- g2: bar vs the 500,000 line ----------
const BARS=el('g',{opacity:0},G);
el('line',{x1:150,y1:1010,x2:900,y2:1010,stroke:'#FFF8EE','stroke-width':8},BARS);
const lim=el('line',{x1:150,y1:590,x2:900,y2:590,stroke:YEL,'stroke-width':8,'stroke-dasharray':'26 18'},BARS);
const limT=el('text',{x:160,y:568,'font-family':'Kanit','font-weight':900,'font-size':52,fill:YEL,stroke:INK,'stroke-width':10,'paint-order':'stroke'},BARS); limT.textContent='500,000 (5 แสน)';
const bar=el('rect',{x:390,y:1010,width:300,height:0,rx:18,fill:ORG,stroke:INK,'stroke-width':9},BARS);
const barT=el('text',{x:540,y:1000,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':58,fill:'#fff',stroke:INK,'stroke-width':12,'paint-order':'stroke'},BARS); barT.textContent='462,240';
const barY=el('text',{x:540,y:1062,'text-anchor':'middle','font-family':'Kanit','font-weight':700,'font-size':40,fill:'#fff'},BARS); barY.textContent='ปี 2567';
const ARD=el('use',{href:'#ic-arrow-down',x:-40,y:-40,width:80,height:80,color:RED,opacity:0},G);
function barsF(t){
  const v=win(t,T.s13,T.s13b,FAST); BARS.setAttribute('opacity',f2(clamp(v*2)));
  const h=420*462240/500000*clamp(S(t-T.s13,9,0.8)); bar.setAttribute('y',f2(1010-h)); bar.setAttribute('height',f2(Math.max(0,h)));
  barT.setAttribute('y',f2(1010-h+70)); lim.setAttribute('stroke-dashoffset',f2(-t*60));
  const va=win(t,T.s13+0.3,T.s13b,POP); ARD.setAttribute('opacity',f2(clamp(va*2)));
  ARD.setAttribute('transform',`translate(780 ${f2(640+10*Math.sin(t*8))}) scale(${sc1(va)})`);
}

// ---------- g3: crowd of young people (illustrative grid) + "อายุ 12-35" ----------
const PPL=[]; for(let r=0;r<4;r++)for(let c=0;c<8;c++)PPL.push({e:el('use',{href:'#ic-user',x:-34,y:-34,width:68,height:68,color:(r+c)%2?GRN:'#C9A8FF',opacity:0},G),x:175+c*104,y:520+r*92,i:r*8+c});
function crowdF(t){
  const out=t>=T.s18b?eo((t-T.s18b)/0.2):0;
  PPL.forEach(p=>{const a=T.s18+0.05+p.i*0.022, v=(t>=a&&t<T.s18b+0.25)?S(t-a,POP[0],POP[1])*(1-out):0;
    p.e.setAttribute('opacity',f2(clamp(v*2))); p.e.setAttribute('transform',`translate(${p.x} ${f2(p.y+5*Math.sin(t*4+p.i))}) scale(${sc1(v)})`);});
  tagAt('age',t,K.num,T.s18b,540,940,-2);
}

// ---------- s19: sound waves at the headphones ----------
const WAV=[0,1,2].map(i=>el('path',{d:'M0 -60 A60 60 0 0 1 0 60',fill:'none',stroke:ORG,'stroke-width':12,'stroke-linecap':'round',opacity:0},G));
function wavesF(t){const on=t>=T.s19&&t<T.s20; WAV.forEach((w,i)=>{if(!on){w.setAttribute('opacity','0');return;} const ph=((t-T.s19)*1.4+i/3)%1;
  w.setAttribute('opacity',f2(Math.sin(ph*Math.PI)*0.9)); w.setAttribute('transform',`translate(${f2(700+ph*120)} 1000) scale(${f2(0.8+ph*1.6)})`);});}

// ---------- split screens ----------
function splitF(t,n,a,open,end){
  const hl=$('hL'+n), hr=$('hR'+n), pr=$('pR'+n), fl=$('fR'+n);
  if(t<a||t>=end+0.15)return;
  const vl=S(t-a-0.05,POP[0],POP[1]); hl.style.transform=`scale(${sc1(vl)}) rotate(${f2(-2+1.2*Math.sin(t*2.2))}deg)`;
  const vr=t>=open?S(t-open,POP[0],POP[1]):0; hr.style.opacity=vr>0.003?'1':'0'; hr.style.transform=`scale(${sc1(vr)}) rotate(${f2(2-1.2*Math.sin(t*2.2))}deg)`;
  const po=t>=open?S(t-open,BOUNCE[0],BOUNCE[1]):0;
  pr.style.transform=`scale(${f2(t<open?0.94+0.015*Math.sin(t*6):0.9+0.1*po)}) rotate(${f2(0.8*Math.sin(t*1.3))}deg)`;
  pr.style.opacity=t<open?'0.55':'1'; fl.style.opacity=t>=open?f2(0.8*(1-clamp((t-open)/0.2))):'0';
  $('pL'+n).style.transform=`rotate(${f2(-0.8*Math.sin(t*1.2))}deg)`;
  $('iL'+n).style.transform=`scale(${f2(1.03+0.07*clamp((t-a)/(end-a)))})`;
  $('iR'+n).style.transform=`scale(${f2(1.03+0.08*clamp((t-open)/(end-open)))})`;
}
// split 1: chat bubbles (flowers "สวัสดีวันจันทร์" / cat)
function split1(t){
  splitF(t,1,T.s07,T.s09,T.s12);
  const b=$('bubF'), vb=win(t,T.s08b,T.s12,BOUNCE); if(show(b,clamp(vb*2))){ const shrink=t>=T.s09?S(t-T.s09,14,0.85):0;
    b.style.transformOrigin='20% 100%'; b.style.transform=`translate(${f2(-20*shrink)}px,${f2(30*shrink+30*(1-clamp(vb)))}px) scale(${sc1(vb*(1-0.25*shrink))}) rotate(${f2(-2+1.5*Math.sin(t*2.5))}deg)`;
    const tx=b.querySelector('.bt'), vt=t>=K.jan?S(t-K.jan,POP[0],POP[1]):0; tx.style.transform=`scale(${sc1(vt)})`;}
  const c=$('bubC'), vc=win(t,T.s10,T.s12,BOUNCE); if(show(c,clamp(vc*2))){ const laugh=(t>=K.lan+0.1&&t<T.s12)?3*Math.sin((t-K.lan)*22)*Math.exp(-(t-K.lan-0.1)*1.5):0;
    c.style.transformOrigin='80% 100%'; c.style.transform=`translateY(${f2(30*(1-clamp(vc)))}px) scale(${sc1(vc)}) rotate(${f2(2+laugh+1.2*Math.sin(t*2.4))}deg)`;}
  tagAt('tagL',t,K.taen,T.s12,690,660,4);
}
// split 2: radio notes + "หา?"
const NOTES=$('notes'); const NT=[...Array(5)].map((_,i)=>el('use',{href:'#ic-music',x:-40,y:-40,width:80,height:80,color:i%2?YEL:'#FFB36B',opacity:0},NOTES));
const EQ=[...Array(6)].map((_,i)=>el('rect',{x:120+i*56,y:0,width:38,height:0,rx:10,fill:YEL,stroke:INK,'stroke-width':6,opacity:0},NOTES));
function split2(t){
  splitF(t,2,T.s14,T.s16,T.s18);
  const on=t>=T.s15&&t<T.s18;
  NT.forEach((n,i)=>{if(!on){n.setAttribute('opacity','0');return;} const ph=((t-T.s15)*1.1+i/5)%1;
    n.setAttribute('opacity',f2(Math.sin(ph*Math.PI))); n.setAttribute('transform',`translate(${f2(150+i*62+40*Math.sin(t*3+i))} ${f2(1000-520*ph)}) rotate(${f2(20*Math.sin(t*4+i))}) scale(${f2(0.7+0.5*ph)})`);});
  const ve=win(t,T.s15,T.s18,POP);
  EQ.forEach((r,i)=>{const h=(40+70*Math.abs(Math.sin(t*(9+i*1.7)+i)))*clamp(ve); r.setAttribute('opacity',f2(clamp(ve*2))); r.setAttribute('y',f2(1060-h)); r.setAttribute('height',f2(h));});
  $('pL2').style.transform+=on?` translate(${f2(4*Math.sin(t*47))}px,${f2(3*Math.cos(t*39))}px)`:'';
  const ha=$('haT'), vh=win(t,K.ha,T.s18,POP); if(show(ha,clamp(vh*2))){ const sh=(t-K.ha<0.6?14:4)*Math.sin(t*70);
    ha.style.transform=`translate(${f2(160+sh)}px,${f2(2*Math.cos(t*60))}px) scale(${sc1(vh)}) rotate(${f2(-6+3*Math.sin(t*30))}deg)`;}
  const ar=$('araiT'), va=win(t,K.arai,T.s18,POP); if(show(ar,clamp(va*2))) ar.style.transform=`translate(160px,0) scale(${sc1(va)}) rotate(${f2(3*Math.sin(t*5))}deg)`;
}
// split 3: zoom on the glasses ("อ่านหนังสือ"), "ทั้งวัน"
const zL3=track(1,[[T.s20b,1.5,SLOW]]);
function split3(t){
  splitF(t,3,T.s20,T.s21,T.s23);
  if(t>=T.s20b&&t<T.s23+0.15){ const i=$('iL3'); i.style.transformOrigin='52% 34%'; i.style.transform=`scale(${f2(zL3(t))})`; }
  $('gzw2').style.opacity=t>=T.s22?'1':'0';
  tagAt('tagB',t,K.aan,T.s23,277,990,-3);
  const v=tagAt('tagD',t,T.s22,T.s23,697,990,3);
  if(v) $('tagDic').style.transform=`rotate(${f2((t-T.s22)*240)}deg)`;
}

// ---------- g4: research doc, 2050, donut ~50%, blur -> sharp ----------
function researchF(t){
  const d=$('doc'), v=win(t,T.s23,T.s23b,BOUNCE); if(show(d,clamp(v*2))) d.style.transform=`translateY(${f2(40*(1-clamp(v))+6*Math.sin(t*2))}px) rotate(${f2(-2+Math.sin(t*1.4))}deg) scale(${sc1(0.85+0.15*v)})`;
  const g=$('globe'), vg=win(t,T.s23+0.15,T.s23b,POP); if(show(g,clamp(vg*2))) g.style.transform=`scale(${sc1(vg)}) rotate(${f2((t-T.s23)*90)}deg)`;
  const dn=$('donut'), vd=win(t,T.s23c,T.s25,BOUNCE); if(!show(dn,clamp(vd*2)))return;
  const fill=0.498*clamp(S(t-K.khrueng,9,0.9)); $('darc').setAttribute('stroke-dasharray',`${f2(1194*fill)} 1194`);
  // s24 "สายตาสั้น": the whole chart goes myopic-blurry on the cut, then focuses
  const bl=t>=T.s24?14*(1-eo((t-T.s24-0.12)/0.55)):0;
  dn.style.filter=bl>0.2?`blur(${f2(bl)}px)`:'none';
  dn.style.transform=`translateY(${f2(30*(1-clamp(vd)))}px) scale(${f2(0.9+0.1*clamp(vd))})`;
  const ve=t>=K.san+0.4?S(t-K.san-0.4,POP[0],POP[1]):0; $('deye').setAttribute('opacity',ve>0.01?'1':'0');
  $('deye').setAttribute('transform',`translate(760 520) scale(${sc1(ve)}) translate(-760 -520)`);
}

// ---------- serious turn: ear, "เตรียมได้", slider, "ถาวร แต่ป้องกันได้" ----------
const RINGS=[0,1,2].map(i=>el('circle',{cx:540,cy:640,r:150,fill:'none',stroke:'#FF8FA0','stroke-width':6,opacity:0},G));
const earV=track(0,[[T.s25+0.05,1,BOUNCE],[T.s26,0,OUT],[T.s27,1,BOUNCE],[T.s28,0,OUT]]);
function seriousF(t){
  const ev=earV(t), e=$('ear');
  if(show(e,clamp(ev*2))) e.style.transform=`translateY(${f2(5*Math.sin(t*2))}px) scale(${sc1(ev*(1+0.03*Math.sin(t*5)))})`;
  const on=(t>=T.s25&&t<T.s26)||(t>=T.s27&&t<T.s28);
  RINGS.forEach((r,i)=>{if(!on||ev<0.3){r.setAttribute('opacity','0');return;} const ph=((t*0.8)+i/3)%1; r.setAttribute('r',f2(150+160*ph)); r.setAttribute('opacity',f2(0.5*(1-ph)));});
  const ta=$('taeT'), vt=win(t,K.tae,T.s26,FAST); if(show(ta,clamp(vt*2))) ta.style.transform=`translateY(${f2(20*(1-clamp(vt)))}px) scale(${sc1(0.9+0.1*vt)})`;
  tagAt('triam',t,K.triam,T.s26,540,920,-2);
  const th=$('thaworn'), vh=win(t,K.mai,T.s28,POP); if(show(th,clamp(vh*2))) th.style.transform=`scale(${sc1(vh)}) rotate(${f2(-2+Math.sin(t*2))}deg)`;
  tagAt('prot',t,K.mai+0.55,T.s28,540,910,2);
  show($('whoS'),pinO(t,K.mai+0.7,T.s28)*0.9);
  const n=$('note'), vn=pinO(t,T.s27+0.1,T.s28); show(n,vn); n.style.transform=`translateY(${f2(10*(1-vn))}px)`;
  // slider: volume knob slides down on "เบาเสียง"
  const s=$('slider'), vs=win(t,T.s26,T.s27,BOUNCE); if(!show(s,clamp(vs*2)))return;
  s.style.transform=`translateY(${f2(T.s26b<=t?260:0)}px) scale(${sc1(0.85+0.15*vs)})`;
  const val=lerp(0.9,0.35,clamp(t>=K.bao?S(t-K.bao,9,0.85):0));
  $('sfil').style.width=f2(540*val)+'px'; $('sknob').style.transform=`translateX(${f2(140+540*val-35)}px)`;
  $('sfil').style.background=mix('#FF4D5E',GRN,clamp((0.9-val)/0.5)); $('volUse').setAttribute('href',val<0.55?'#ic-volume-1':'#ic-volume-2');
}

// ---------- ending: ยุคนี้ + Gen Z merge on the couple, comment bubble, loop ----------
function endF(t){
  // split tint on the couple card slides apart = the two sides become one picture
  const m=t>=T.s28?eo((t-T.s28-0.05)/0.45):0; $('mgL').style.opacity=f2(0.75*(1-m)); $('mgR').style.opacity=f2(0.75*(1-m));
  $('mgL').style.transform=`translateX(${f2(-430*m)}px)`; $('mgR').style.transform=`translateX(${f2(430*m)}px)`;
  const mg=t>=T.s28?clamp(S(t-T.s28,14,0.8)):0, gone=t>=K.tonkae?1:0;
  if(t>=T.s28&&t<K.tonkae+0.1){ const o=1-clamp((t-K.tonkae)/0.08);
    [['chYA',280,-1],['chYB',800,1]].forEach(([id,x,s])=>{const e=$(id); e.style.opacity=f2(o); const w=e.offsetWidth||200;
      e.style.transform=`translate(${f2(lerp(x,540+s*110,mg)-w/2)}px,${f2(370-38)}px) rotate(${f2(s*3)}deg) scale(${sc1(S(t-T.s28,POP[0],POP[1]))})`;}); }
  else {$('chYA').style.opacity='0'; $('chYB').style.opacity='0';}
  const b=$('cbub'), endFade=1-clamp((t-(DUR-0.36))/0.1), vb=win(t,T.s28b,DUR,BOUNCE)*endFade;
  if(show(b,clamp(vb*2))){ const up=t>=T.s29?S(t-T.s29,14,0.85):0;
    b.style.transform=`translate(0px,${f2(-80*up+20*(1-clamp(vb)))}px) scale(${sc1(Math.max(0.001,vb)*(1-0.2*up))}) rotate(${f2(-1.5*Math.sin(t*2))}deg)`;
    const hq=t>=K.baepnai?clamp(S(t-K.baepnai,14,0.8)):0; $('q2').style.background=`rgba(255,225,77,${f2(hq)})`; $('q2').style.transform=`scale(${f2(1+0.06*Math.sin(clamp((t-K.baepnai)/0.3)*Math.PI)*(t>=K.baepnai?1:0))})`;
    const q3=t>=K.ment?S(t-K.ment,POP[0],POP[1]):0; $('q3').style.opacity=f2(clamp(q3)); $('q3').style.transform=`translateY(${f2(16*(1-clamp(q3)))}px)`; }
  tagAt('choA',t,K.baepnai+0.1,T.s29,320,940,-4);
  tagAt('choB',t,K.baepnai+0.25,T.s29,720,940,4);
}

// ---------- captions: spring in on the word; last chunk clears before the loop seam ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  const fade=i===CAPT.length-1?1-clamp((t-(DUR-0.17))/0.1):1;
  capEls[i].style.opacity=f2(fade);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); stars(t); fx(t); title(t); yearF(t); pillF(t); hookExtras(t); timelineF(t); bigF(t); barsF(t); crowdF(t);
  wavesF(t); split1(t); split2(t); split3(t); researchF(t); seriousF(t); endF(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
