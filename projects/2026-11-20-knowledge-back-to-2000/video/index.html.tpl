<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<script src="vendor/d3-path.min.js"></script>
<script src="vendor/d3-shape.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#140E08}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 45%,rgba(20,12,6,0) 55%,rgba(20,12,6,.5) 100%)}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
.ic{overflow:visible}
/* film grain over the past (registry: grain-overlay, driven by timeline time instead of a CSS loop) */
#grain-overlay{position:absolute;left:0;top:0;width:1080px;height:1920px;pointer-events:none;z-index:5;overflow:hidden;opacity:0}
#grain-overlay .grain-texture{position:absolute;top:-50%;left:-50%;width:200%;height:200%;opacity:.15;
  background:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")}
/* CRT (hook / outro): scanlines + a rolling bright band */
#crt{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:6;pointer-events:none;opacity:0;
  background:repeating-linear-gradient(rgba(0,0,0,.22) 0 3px,rgba(0,0,0,0) 3px 7px)}
#crtRoll{position:absolute;left:0;top:0;width:1080px;height:260px;background:linear-gradient(rgba(255,255,255,0),rgba(255,255,255,.09),rgba(255,255,255,0))}
#tshade{position:absolute;left:0;top:0;width:1080px;height:900px;background:linear-gradient(rgba(8,6,18,.8) 0%,rgba(8,6,18,.55) 60%,rgba(8,6,18,0) 100%)}
.ttl{position:absolute;left:0;top:0;width:1080px;height:760px}
.ttl .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:24px #10080A;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
.ttl em{font-style:normal;color:#FFE14D}
/* the year: one element, big in hook/outro, small inside the HUD in between (scan-band from the registry on the spins) */
#year{position:absolute;left:-470px;top:-170px;width:940px;height:340px;text-align:center;transform-origin:50% 50%;opacity:0}
#year span{position:absolute;left:0;top:0;width:940px;height:340px;text-align:center;font-weight:900;font-size:300px;line-height:340px;white-space:nowrap;
  font-variant-numeric:tabular-nums;letter-spacing:4px}
#yv{color:#fff;-webkit-text-stroke:26px #10080A;paint-order:stroke fill}
.sb-band{position:absolute;left:0;top:0;width:940px;height:340px;overflow:hidden;--p:-60%;
  clip-path:polygon(calc(var(--p) - 9%) 0%,calc(var(--p) + 9%) 0%,calc(var(--p) + 25%) 100%,calc(var(--p) + 7%) 100%)}
.sb-band .r{color:#ff3158;transform:translateX(-14px)}
.sb-band .c{color:#36efff;transform:translateX(22px);opacity:.9}
.sb-band .k{color:#FFE14D;-webkit-text-stroke:26px #10080A;paint-order:stroke fill;transform:translateX(8px)}
/* HUD */
#hud{position:absolute;left:60px;top:250px;width:960px;height:300px;border-radius:28px;background:rgba(18,12,38,.88);opacity:0;transform-origin:50% 0;
  box-shadow:0 0 0 6px #10080A,inset 0 0 0 4px #FFE14D,0 16px 0 rgba(0,0,0,.35)}
.st{position:absolute;top:16px;height:132px;border-radius:20px;background:rgba(255,255,255,.08)}
.st .lb{position:absolute;left:18px;top:8px;display:flex;align-items:center;gap:8px;color:#D9D2FF;font-weight:700;font-size:30px;white-space:nowrap}
.st .lb svg{width:34px;height:34px;color:#FFE14D}
#sYear{left:16px;width:300px}#sAge{left:330px;width:250px}#sMoney{left:594px;width:350px}
#age{position:absolute;left:0;top:40px;width:250px;text-align:center;font-weight:900;font-size:78px;line-height:96px;color:#fff;-webkit-text-stroke:10px #10080A;paint-order:stroke fill;transform-origin:50% 55%}
#age small{font-size:36px;font-weight:700;-webkit-text-stroke:6px #10080A}
#mTrack{position:absolute;left:20px;top:70px;width:240px;height:44px;border-radius:22px;background:rgba(255,255,255,.14);box-shadow:0 0 0 4px #10080A}
#mBar{position:absolute;left:0;top:0;height:44px;width:30px;border-radius:22px;background:#FFE14D}
#mUp,#mDn{position:absolute;left:272px;top:54px;width:70px;height:70px;opacity:0}
#mUp{color:#3DDC84}#mDn{color:#FF4D5E}
#disc{position:absolute;left:0;top:254px;width:960px;text-align:center;color:#FFE14D;font-weight:700;font-size:32px;opacity:0;white-space:nowrap}
/* mission checklist: one row, lives in the HUD, moves down for the outro */
#chk{position:absolute;left:0;top:0;width:860px;height:84px;transform-origin:0 0;opacity:0}
.it{position:absolute;top:0;width:280px;height:84px;display:flex;align-items:center;gap:12px;white-space:nowrap}
.it .bx{position:relative;flex:0 0 60px;width:60px;height:60px;border-radius:14px;border:6px solid #fff;background:rgba(255,255,255,.08);box-shadow:0 0 0 4px #10080A}
.it .bx svg{position:absolute;left:-2px;top:-2px;width:52px;height:52px}
.it .tx{color:#fff;font-weight:900;font-size:42px;-webkit-text-stroke:8px #10080A;paint-order:stroke fill;display:flex;align-items:center;gap:6px}
.it .tx svg{width:40px;height:40px;color:#F7931A}
/* generic chips / bubbles / cards */
.chip{position:absolute;left:0;top:0;height:112px;padding:0 36px 0 28px;border-radius:30px;border:7px solid #10080A;background:#2A1A4A;
  display:flex;align-items:center;gap:16px;color:#fff;font-weight:900;font-size:66px;white-space:nowrap;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.4);transform-origin:50% 50%}
.chip svg{width:62px;height:62px;color:#FFE14D}
.bub{position:absolute;left:0;top:0;padding:14px 40px 22px;border-radius:44px;border:7px solid #10080A;background:#FFF8EE;color:#10080A;
  font-weight:900;font-size:62px;white-space:nowrap;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.35);transform-origin:20% 100%}
.bub:after{content:'';position:absolute;left:70px;bottom:-40px;width:44px;height:44px;background:#FFF8EE;border-right:7px solid #10080A;border-bottom:7px solid #10080A;transform:skewY(40deg) rotate(30deg)}
.bub.r{transform-origin:80% 100%}.bub.r:after{left:auto;right:70px;transform:skewY(-40deg) rotate(-30deg);border-right:0;border-left:7px solid #10080A}
.big{position:absolute;left:0;top:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;opacity:0;
  -webkit-text-stroke:24px #10080A;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.4)}
.card{position:absolute;border-radius:36px;background:#1F1538;opacity:0;transform-origin:50% 50%;
  box-shadow:0 0 0 7px #FFF8EE,0 0 0 14px #10080A,0 30px 70px rgba(0,0,0,.5)}
/* future-knowledge bubbles */
.fz{position:absolute;left:0;top:0;width:160px;height:160px;border-radius:80px;border:8px solid #10080A;opacity:0;box-shadow:0 10px 0 rgba(0,0,0,.35)}
.fz svg{position:absolute;left:24px;top:24px;width:96px;height:96px;color:#10080A}
/* lock card */
#lockc{left:150px;top:620px;width:760px;height:440px}
#lockIc{position:absolute;left:290px;top:28px;width:180px;height:180px;border-radius:90px;background:#FFE14D;border:8px solid #10080A}
#lockIc svg{position:absolute;left:30px;top:26px;width:104px;height:104px;color:#10080A}
.lt{position:absolute;left:0;top:226px;width:760px;text-align:center;font-weight:900;font-size:84px;line-height:1.1;color:#fff;white-space:nowrap}
.lt em{font-style:normal;color:#FFE14D;display:inline-block}
.ls{position:absolute;left:0;top:338px;width:760px;text-align:center;font-weight:700;font-size:44px;color:#FF8A95;white-space:nowrap}
#ageTr{position:absolute;left:120px;top:356px;width:520px;height:40px;border-radius:20px;background:rgba(255,255,255,.14)}
#ageFill{position:absolute;left:0;top:0;height:40px;width:0;border-radius:20px;background:#FF4D5E}
.atk{position:absolute;top:-6px;font-weight:900;font-size:40px;color:#fff;line-height:52px}
/* price card */
#pc{left:120px;top:612px;width:780px;height:452px}
#pcH{position:absolute;left:36px;top:24px;display:flex;align-items:center;gap:14px;color:#FFE14D;font-weight:900;font-size:50px;white-space:nowrap}
#pcH svg{width:56px;height:56px;color:#FFE14D}
.pr{position:absolute;left:36px;width:720px;height:150px}
.pr .pl{position:absolute;left:0;top:0;color:#D9D2FF;font-weight:700;font-size:38px;white-space:nowrap}
.pr .pv{position:absolute;left:0;top:40px;font-weight:900;font-size:92px;line-height:1;white-space:nowrap;font-variant-numeric:tabular-nums}
.pr .pv small{font-size:42px;font-weight:700;margin-left:10px}
.pr .pb{position:absolute;left:392px;top:68px;height:50px;width:0;border-radius:12px;border:5px solid #10080A}
.pr svg{position:absolute;left:668px;top:54px;width:64px;height:64px;color:#3DDC84;opacity:0}
#pcF{position:absolute;left:0;top:404px;width:780px;text-align:center;color:rgba(255,255,255,.8);font-weight:700;font-size:32px;white-space:nowrap}
/* bitcoin coin: the generic B-with-strokes symbol (lucide "bitcoin"), no company logo */
#btc{position:absolute;left:-100px;top:-100px;width:200px;height:200px;border-radius:100px;background:#F7931A;border:9px solid #10080A;opacity:0;box-shadow:0 12px 0 rgba(0,0,0,.35)}
#btc svg{position:absolute;left:30px;top:30px;width:122px;height:122px;color:#fff}
#crashL{left:468px;top:880px;width:432px;height:190px}
#crashL .t{position:absolute;left:0;top:14px;width:432px;text-align:center;color:#fff;font-weight:900;font-size:64px;white-space:nowrap}
#crashL .t em{font-style:normal;color:#FF4D5E}
#cTr{position:absolute;left:36px;top:118px;width:360px;height:42px;border-radius:12px;background:rgba(255,255,255,.14)}
#cBar{position:absolute;left:0;top:0;height:42px;width:360px;border-radius:12px;background:#FF4D5E}
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
  <div class="sc" id="sh-hook_year"><div class="kb" id="kb-hook_year">%%V_HOOK_YEAR%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-wake_bed"><div class="kb" id="kb-wake_bed">%%V_WAKE_BED%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-future_mind"><div class="kb" id="kb-future_mind">%%V_FUTURE_MIND%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-kid_hands"><div class="kb" id="kb-kid_hands">%%V_KID_HANDS%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-kid_school"><div class="kb" id="kb-kid_school">%%V_KID_SCHOOL%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-locked"><div class="kb" id="kb-locked">%%V_LOCKED%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-age20"><div class="kb" id="kb-age20">%%V_AGE20%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-gold"><div class="kb" id="kb-gold">%%V_GOLD%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-gold_mom"><div class="kb" id="kb-gold_mom">%%V_GOLD_MOM%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-gold_price"><div class="kb" id="kb-gold_price">%%V_GOLD_PRICE%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-gold_now"><div class="kb" id="kb-gold_now">%%V_GOLD_NOW%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-stock"><div class="kb" id="kb-stock">%%V_STOCK%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-stock_dad"><div class="kb" id="kb-stock_dad">%%V_STOCK_DAD%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-set_price"><div class="kb" id="kb-set_price">%%V_SET_PRICE%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-set_now"><div class="kb" id="kb-set_now">%%V_SET_NOW%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-piggy"><div class="kb" id="kb-piggy">%%V_PIGGY%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-coins"><div class="kb" id="kb-coins">%%V_COINS%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-teen"><div class="kb" id="kb-teen">%%V_TEEN%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-parents_again"><div class="kb" id="kb-parents_again">%%V_PARENTS_AGAIN%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-crash"><div class="kb" id="kb-crash">%%V_CRASH%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-hold"><div class="kb" id="kb-hold">%%V_HOLD%%</div><div class="vig"></div></div>
  <div class="sc" id="sh-outro"><div class="kb" id="kb-outro">%%V_OUTRO%%</div><div class="vig"></div></div>
</div>
<div id="grain-overlay"><div class="grain-texture" id="grainTx"></div></div>
<div id="crt"><div id="crtRoll"></div></div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:10">
  <div id="tshade"></div>
  <!-- HUD shell (stats + disclaimer); year and checklist are separate so they can travel -->
  <div id="hud">
    <div class="st" id="sYear"><div class="lb"><svg class="ic"><use href="#ic-calendar"/></svg>ปีในเรื่อง</div></div>
    <div class="st" id="sAge"><div class="lb"><svg class="ic"><use href="#ic-baby"/></svg>อายุ (ปี)</div><div id="age">33</div></div>
    <div class="st" id="sMoney"><div class="lb"><svg class="ic"><use href="#ic-banknote"/></svg>เงินเรา</div>
      <div id="mTrack"><div id="mBar"></div></div>
      <svg class="ic" id="mUp"><use href="#ic-trending-up"/></svg><svg class="ic" id="mDn"><use href="#ic-trending-down"/></svg></div>
    <div id="disc">แค่สมมุติ ไม่ใช่คำแนะนำลงทุน</div>
  </div>
  <div id="chk">
    <div class="it" id="it0" style="left:0"><div class="bx" id="bx0"><svg class="ic" id="ck0" style="color:#fff"><use href="#ic-check"/></svg></div><div class="tx">1 ทอง</div></div>
    <div class="it" id="it1" style="left:290px"><div class="bx" id="bx1"><svg class="ic" id="ck1" style="color:#fff"><use href="#ic-check"/></svg></div><div class="tx">2 หุ้น</div></div>
    <div class="it" id="it2" style="left:580px"><div class="bx" id="bx2"><svg class="ic" id="ck2" style="color:#10080A"><use href="#ic-circle-help"/></svg></div><div class="tx">3 บิตคอยน์</div></div>
  </div>
  <!-- future knowledge -->
  <div class="fz" id="fz0" style="background:#FFC83D"><svg class="ic"><use href="#ic-coins"/></svg></div>
  <div class="fz" id="fz1" style="background:#3DDC84"><svg class="ic"><use href="#ic-trending-up"/></svg></div>
  <div class="fz" id="fz2" style="background:#F7931A"><svg class="ic" style="color:#fff"><use href="#ic-bitcoin"/></svg></div>
  <!-- "wait..." -->
  <div class="big" id="huh" style="font-size:190px;color:#FF4D5E">!?</div>
  <div class="chip" id="age8" style="background:#B0306F"><svg class="ic"><use href="#ic-baby"/></svg>เพิ่ง 8 ขวบ</div>
  <div class="big" id="p2" style="font-size:250px;color:#FFE14D">ป.2</div>
  <div class="chip" id="bag" style="background:#1E5AA8;padding:0 22px"><svg class="ic" style="width:80px;height:80px"><use href="#ic-backpack"/></svg></div>
  <!-- locked account -> must be 20 -->
  <div class="card" id="lockc"><div id="lockIc"><svg class="ic"><use href="#ic-lock"/></svg></div>
    <div class="lt" id="lt1">บัญชีหุ้น</div><div class="ls" id="ls1">เปิดเองไม่ได้</div>
    <div class="lt" id="lt2">ต้องอายุ <em id="l20">20</em></div>
    <div id="ageTr"><div id="ageFill"></div><div class="atk" id="atk8" style="left:0">8</div><div class="atk" style="left:530px">20</div></div></div>
  <!-- missions -->
  <div class="bub" id="bubM">แม่~ ซื้อทองเก็บไว้นะ</div>
  <div class="bub r" id="bubD">พ่อ~ ซื้อหุ้นไทยหน่อย</div>
  <div class="card" id="pc"><div id="pcH"><svg class="ic" id="pcIc"><use id="pcUse" href="#ic-coins"/></svg><span id="pcHt">ทองแท่ง · บาทละ</span></div>
    <div class="pr" id="prA" style="top:104px"><div class="pl" id="plA">ปี 2000</div><div class="pv" id="pvA" style="color:#fff">0</div><div class="pb" id="pbA" style="background:#C9B27A"></div></div>
    <div class="pr" id="prB" style="top:250px"><div class="pl" id="plB">พ.ย. 69</div><div class="pv" id="pvB" style="color:#3DDC84">0</div><div class="pb" id="pbB" style="background:#3DDC84"></div>
      <svg class="ic" id="pUp"><use href="#ic-trending-up"/></svg></div>
    <div id="pcF">ราคาทองแท่ง ณ พ.ย. 69</div></div>
  <svg class="ov" id="gsvg" viewBox="0 0 1080 1920" width="1080" height="1920"><g id="glayer"></g></svg>
  <div id="btc"><svg class="ic"><use href="#ic-bitcoin"/></svg></div>
  <div class="chip" id="btcL" style="background:#7A4A12"><svg class="ic"><use href="#ic-calendar"/></svg>มีให้ซื้อปี 2010</div>
  <div class="chip" id="mpl" style="background:#1E5AA8"><svg class="ic"><use href="#ic-graduation-cap"/></svg>ม.ปลาย</div>
  <div class="bub" id="bP">พ่อ~</div>
  <div class="bub r" id="bMo">แม่~</div>
  <div class="big" id="again" style="font-size:150px;color:#FF4D5E">อีกรอบ!</div>
  <div class="card" id="crashL"><div class="t">เคยร่วง <em>~90%</em></div><div id="cTr"><div id="cBar"></div></div></div>
  <div class="big" id="holdT" style="font-size:170px;color:#FFE14D">ถือไหวป่ะ?</div>
  <div class="chip" id="cmt" style="background:#FFE14D;color:#10080A;font-size:50px;height:92px"><svg class="ic" style="color:#10080A;width:52px;height:52px"><use href="#ic-message-circle"/></svg>ตอบในคอมเมนต์</div>
  <!-- titles: hook question (frame 0) and outro question; both are the spoken line word for word -->
  <div class="ttl" id="htitle"><div class="tl" id="h1">ถ้าตื่นมา</div><div class="tl" id="h2">เป็นปี 2000</div><div class="tl" id="h3">จะ<em>รวย</em>ยังไง?</div></div>
  <div class="ttl" id="otitle"><div class="tl" id="o1">ถ้าเป็นนาย</div><div class="tl" id="o2">จะทำ<em>ต่าง</em>จากเรา</div><div class="tl" id="o3">ยังไง?</div></div>
  <div id="year"><span id="yv">2026</span><div class="sb-band" id="yband"><span class="r">2026</span><span class="c">2026</span><span class="k">2026</span></div></div>
</div>
</div>
<div id="gbars"><div id="gb0"></div><div id="gb1"></div><div id="gb2"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-b6fb4ded.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine, from the brainrot template). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). The hero is the game HUD: ONE year element (big in the
   hook/outro, small in the HUD), age, the "เงินเรา" meter (bar + arrow, no money amounts) and the mission checklist.
   Everything is a function of t. */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh, CEND=D.cend;
const T={}; for(const k in SH)T[k]=SH[k].start;
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
const fmt=n=>Math.round(n).toLocaleString('en-US');
const YEL='#FFE14D',GRN='#3DDC84',RED='#FF4D5E',INK='#10080A';
const G=$('glayer');
const OSPIN=K.nai, OLAND=K.nai+0.8;   // outro: year spins 2010 -> 2026, lands back in the present (cool look)

// ---------- scenes ----------
// entries: cut (hard) | whip (0.12 s push) | zoom (zoom punch-in, 0.1 s fade) | match (0.1 s crossfade)
const ENT=[['hook_year','none'],['wake_bed','whip'],['future_mind','match'],['kid_hands','zoom'],['kid_school','cut'],['locked','zoom'],
 ['age20','match'],['gold','whip'],['gold_mom','cut'],['gold_price','zoom'],['gold_now','match'],['stock','whip'],['stock_dad','cut'],
 ['set_price','zoom'],['set_now','match'],['piggy','whip'],['coins','cut'],['teen','zoom'],['parents_again','match'],['crash','cut'],
 ['hold','zoom'],['outro','cut']];
const ORG=['45% 35%','55% 40%','50% 45%','40% 40%','60% 35%','50% 50%'];
const SC=ENT.map(([id,inn],i)=>({id:'sh-'+id,a:T[id],kb:'kb-'+id,in:inn,s0:1.02,s1:1.12,r0:i%2?-0.7:0.7,r1:i%2?0.7:-0.7,org:ORG[i%ORG.length]}));
Object.assign(SC[0],{s0:1.0,s1:1.06,org:'50% 45%',still:1});
Object.assign(SC[SC.length-1],{s0:1.06,s1:1.0,org:'50% 45%',still:1});   // ends at the frame-0 scale (loop)
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1); $(s.kb).style.transformOrigin=s.org;});
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
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    const k=lerp(s.s0,s.s1,s.still?uu:eio(0.1+0.9*uu));
    if(s.still){ $(s.kb).style.transform=`scale(${k.toFixed(5)})`; return; }
    const rr=lerp(s.r0,s.r1,uu), dx=12*Math.sin(t*1.7+s.a), dy=9*Math.cos(t*1.3+s.a);
    $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
  });
  // 2026 (cool) <-> 2000 (warm/sepia) swap on the glitch frames: hook at "ปี", outro when the year lands on 2026
  const fl=(a,t)=>{const i=Math.floor((t-a)*30); return i>=0&&i<4?(i%2?1:0):-1;};
  let w=t>=K.pee?1:0, f=fl(K.pee,t); if(f>=0)w=f; show($('v-hook_year-hookw'),w);
  let wo=t<OLAND?1:0, fo=fl(OLAND,t); if(fo>=0)wo=1-fo; show($('v-outro-hookw'),wo);
}

// ---------- film grain (past only) + CRT (hook/outro) ----------
const GOFS=[[0,0],[-5,-5],[-10,5],[5,-10],[-5,15],[-10,5],[15,0],[0,10],[-15,0],[10,5]];
function texture(t){
  const past=t>=T.wake_bed&&t<T.outro; show($('grain-overlay'),past?1:0);
  if(past){const o=GOFS[Math.floor(t*12)%10]; $('grainTx').style.transform=`translate(${o[0]}%,${o[1]}%)`;}
  const crt=t<T.wake_bed?1:(t>=T.outro?1:0); show($('crt'),crt*0.85);
  $('crtRoll').style.transform=`translateY(${f2(((t*520)%2180)-260)}px)`;
}

// ---------- punches + glitch (registry zoom-through / rgb-glitch-text, adapted) ----------
const PUNCH=[K.y2000,K.wait,K.p2,K.hok,K.panha,K.ruang,K.wai,OLAND];
const GL=[K.pee,T.crash,T.outro,OLAND], GLD=0.134;
const GOFF=[[10,-8,-14],[-8,10,-6],[12,-6,-16],[-6,6,-8]];
function fx(t){
  let p=0; PUNCH.forEach(a=>{const u=t-a; if(u>=0&&u<0.8)p+=0.07*Math.exp(-u*7)*Math.cos(u*13);});
  let gi=-1; GL.forEach(a=>{if(t>=a&&t<a+GLD)gi=Math.floor((t-a)*30);});
  const st=$('stage');
  if(gi>=0){const o=GOFF[gi%4]; $('rgbR').setAttribute('dx',o[0]); $('rgbB').setAttribute('dx',o[1]); st.style.filter='url(#rgbx)';
    st.style.transform=`translateX(${o[2]}px) scale(${(1+p).toFixed(4)})`;}
  else { st.style.filter='none'; st.style.transform=`scale(${(1+p).toFixed(4)})`; }
  ['gb0','gb1','gb2'].forEach((id,i)=>{const b=$(id); if(gi<0){b.style.opacity='0';return;}
    const y=[(300+gi*410)%1100,(820+gi*290)%1100,(560+gi*530)%1100][i]+250, h=[26,60,14][i];
    b.style.top=y+'px'; b.style.height=h+'px'; b.style.background=['#22d3ee','#ef4444','#FFFFFF'][i]; b.style.opacity=['.55','.45','.6'][i];
    b.style.transform=`translateX(${(i%2?-1:1)*(20+gi*9)}px)`;});
}

// ---------- titles: hook question complete at frame 0 (no fade-in), breathes 1.0<->1.04; outro question springs in ----------
[['h1',250,140],['h2',400,140],['h3',548,150],['o1',250,140],['o2',404,122],['o3',548,150]].forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
function titles(t){
  const out=eo((t-(T.wake_bed-0.04))/0.12), ho=1-out;
  show($('htitle'),ho); const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/0.9));
  ['h1','h2','h3'].forEach((id,i)=>{$(id).style.transform=`translateY(${f2(3*Math.sin(t*3+i))}px) rotate(${f2(i===2?-1.2*Math.sin(t*2.4):0)}deg) scale(${(br*(1+0.25*out)).toFixed(4)})`;});
  const oi=t>=T.outro?1:0; show($('otitle'),oi);
  ['o1','o2','o3'].forEach((id,i)=>{const a=S(t-T.outro-0.04-i*0.07,POP[0],POP[1]); $(id).style.opacity=f2(clamp(a*1.5));
    $(id).style.transform=`translateY(${f2(3*Math.sin(t*3+i))}px) rotate(${f2(i===1?-1.2*Math.sin(t*2.4):0)}deg) scale(${(Math.max(0.001,a)*br).toFixed(4)})`;});
  show($('tshade'),Math.max(ho,oi));
}

// ---------- the year (one element): big centre <-> HUD slot ----------
function yearVal(t){
  if(t<0.3)return 2026;
  if(t<K.y2000)return Math.round(lerp(2026,2000,eo((t-0.3)/(K.y2000-0.3))));
  if(t<K.kwa)return 2000;
  if(t<K.sue)return Math.round(lerp(2000,2010,eio((t-K.kwa)/(K.sue-K.kwa))));
  if(t<OSPIN)return 2010;
  if(t<OLAND)return Math.round(lerp(2010,2026,eo((t-OSPIN)/(OLAND-OSPIN))));
  return 2026;
}
const SPINS=[[0.3,K.y2000],[K.kwa,K.sue],[OSPIN,OLAND]], LANDS=[K.y2000,K.sue,OLAND];
const yspans=[...document.querySelectorAll('#year span')];
function year(t){
  const y=$('year'); y.style.opacity='1';
  const toH=t>=T.wake_bed?S(t-T.wake_bed,15,0.84):0, back=t>=T.outro?S(t-T.outro,15,0.84):0, u=toH*(1-back);
  const cx=lerp(540,226,u), cy=lerp(905,345,u)+(1-u)*6*Math.sin(t*2.6), sc0=lerp(1,0.25,u);
  let land=0; LANDS.forEach(a=>{const d=t-a; if(d>=0&&d<0.9)land+=0.22*Math.exp(-d*6)*Math.cos(d*15);});
  const br=(1-u)*0.03*(0.5-0.5*Math.cos(t*2*Math.PI/0.9));
  y.style.transform=`translate(${f2(cx)}px,${f2(cy)}px) rotate(${f2((1-u)*-2*Math.sin(t*1.3))}deg) scale(${(sc0*(1+land+br)).toFixed(4)})`;
  const v=String(yearVal(t)); yspans.forEach(s=>{if(s.textContent!==v)s.textContent=v;});
  // scan band (registry scan-band): sweeps across while the digits spin
  let p=-60, on=false; SPINS.forEach(([a,b])=>{if(t>=a&&t<b+0.25){on=true; p=lerp(-30,140,clamp((t-a)/(b+0.25-a)));}});
  $('yband').style.setProperty('--p',p.toFixed(1)+'%'); $('yband').style.opacity=on?'1':'0';
  $('yv').style.color=(t>=K.kwa&&t<K.sue+0.6)?mix('#FFFFFF',YEL,Math.sin(clamp((t-K.kwa)/(K.sue+0.6-K.kwa))*Math.PI)):'#fff';
}

// ---------- HUD: shell, age, money meter, disclaimer ----------
const money=track(0.12,[[K.hok,0.46,BOUNCE],[K.panha,0.8,BOUNCE],[K.ruang,0.07,FAST]]);
function ageVal(t){
  if(t<K.wait)return 33; if(t<K.wait+0.35)return Math.round(lerp(33,8,eo((t-K.wait)/0.35)));
  if(t<K.khuen)return 8; if(t<K.mplai)return Math.round(lerp(8,17,eio((t-K.khuen)/(K.mplai-K.khuen)))); return 17;
}
const ageEl=$('age');
function hud(t){
  const v=t<T.wake_bed?0:(t<T.outro?S(t-T.wake_bed,POP[0],POP[1]):1-clamp((t-T.outro)/0.12));
  const h=$('hud'); if(!show(h,clamp(v*1.4)))return;
  h.style.transform=`translateY(${f2(-24*(1-clamp(v)))}px) scale(${f2(Math.max(0.001,0.9+0.1*v))})`;
  const a=String(ageVal(t)); if(ageEl.textContent!==a)ageEl.textContent=a;
  let bump=0; [K.wait,K.mplai].forEach(k=>{const d=t-k; if(d>=0&&d<1)bump+=0.55*Math.exp(-d*5)*Math.cos(d*16);});
  const red=t>=K.wait&&t<K.wait+1.6?1-clamp((t-K.wait-1.2)/0.4):0;
  ageEl.style.color=mix('#FFFFFF',RED,red); ageEl.style.transform=`scale(${f2(1+bump)}) rotate(${f2(red*4*Math.sin(t*40)*Math.exp(-(t-K.wait)*3))}deg)`;
  $('sAge').style.background=red>0?`rgba(255,77,94,${f2(0.35*red)})`:'rgba(255,255,255,.08)';
  const m=money(t); $('mBar').style.width=f2(Math.max(30,240*clamp(m,0,1.1)))+'px';
  const crashed=t>=K.ruang, up=t>=K.hok&&!crashed;
  $('mBar').style.background=crashed?RED:(t>=K.hok?GRN:YEL);
  const upO=up?S(t-(t>=K.panha?K.panha:K.hok),POP[0],POP[1]):0;
  $('mUp').style.opacity=f2(clamp(upO)); $('mUp').style.transform=`translateY(${f2(-6*Math.sin(t*6))}px) scale(${f2(Math.max(0.001,upO))})`;
  const dn=crashed?S(t-K.ruang,POP[0],POP[1]):0; $('mDn').style.opacity=f2(clamp(dn)); $('mDn').style.transform=`translateY(${f2(5*Math.sin(t*8))}px) scale(${f2(Math.max(0.001,dn))})`;
  $('sMoney').style.background=crashed&&t<K.ruang+1.2?`rgba(255,77,94,${f2(0.35*(1-clamp((t-K.ruang-0.8)/0.4)))})`:(up&&t<K.hok+0.8)||(t>=K.panha&&t<K.panha+0.8)?'rgba(61,220,132,.25)':'rgba(255,255,255,.08)';
  show($('disc'),pinO(t,T.gold,T.outro));
  $('sYear').style.background=(t>=K.kwa&&t<K.sue+0.6)?'rgba(255,225,77,.25)':'rgba(255,255,255,.08)';
}

// ---------- mission checklist: ticks on "ภารกิจแรก/สอง", #3 pulses (never ticked) and turns into "?" in the outro ----------
function checklist(t){
  const c=$('chk'), v=t<T.wake_bed?0:S(t-T.wake_bed-0.08,POP[0],POP[1]); if(!show(c,clamp(v*1.4)))return;
  const u=t>=T.outro?S(t-T.outro,15,0.84):0;
  c.style.transform=`translate(${f2(lerp(110,123,u))}px,${f2(lerp(406,1110,u)-14*(1-clamp(v)))}px) scale(${f2(lerp(1,0.9,u))})`;
  [K.m1,K.m2].forEach((k,i)=>{const p=t>=k?S(t-k,POP[0],POP[1]):0, bx=$('bx'+i);
    bx.style.background=mix('#2A2348',GRN,clamp(p*1.5)); $('ck'+i).style.transform=`scale(${f2(Math.max(0.001,p))})`;
    $('it'+i).style.transform=`scale(${f2(1+(t>=k&&t<k+0.8?0.35*Math.exp(-(t-k)*5)*Math.cos((t-k)*14):0))})`;});
  const pulse=t>=K.m3&&t<T.outro?0.5+0.5*Math.sin((t-K.m3)*9):0, q=t>=K.nai?S(t-K.nai,POP[0],POP[1]):0;
  $('bx2').style.borderColor=t>=K.m3?mix('#FFFFFF',YEL,t<T.outro?pulse:1):'#fff';
  $('bx2').style.background=mix('#2A2348','#FFA53D',clamp(q*1.5));
  $('it2').style.transform=`scale(${f2(1+0.08*pulse+(t>=K.nai&&t<K.nai+0.8?0.3*Math.exp(-(t-K.nai)*5)*Math.cos((t-K.nai)*14):0))})`;
  $('ck2').style.transform=`scale(${f2(Math.max(0.001,q))}) rotate(${f2(10*Math.sin(t*5)*clamp(q))}deg)`;
}

// ---------- future_mind: what we "know" about the future ----------
function future(t){
  [[300,690],[540,650],[780,690]].forEach(([x,y],i)=>{const e=$('fz'+i), v=win(t,K.roo+i*0.12,T.kid_hands,BOUNCE);
    if(show(e,clamp(v*2)))e.style.transform=`translate(${f2(x-80)}px,${f2(y-80+8*Math.sin(t*3+i))}px) rotate(${f2(6*Math.sin(t*2+i))}deg) scale(${f2(Math.max(0.001,v))})`;});
}
// ---------- kid_hands / kid_school: "!?" -> "เพิ่ง 8 ขวบ" chip; giant "ป.2" + school bag ----------
function kid(t){
  const h=$('huh'), vh=win(t,K.wait,K.pee2,POP);
  if(show(h,clamp(vh*2)))h.style.transform=`translateY(${f2(615)}px) rotate(${f2(-6+5*Math.sin(t*20)*Math.exp(-(t-K.wait)*4))}deg) scale(${f2(Math.max(0.001,vh))})`;
  const c=$('age8'), vc=win(t,K.pee2,T.kid_school,BOUNCE);
  if(show(c,clamp(vc*2)))c.style.transform=`translate(${f2(540-c.offsetWidth/2)}px,${f2(640)}px) rotate(${f2(-3+2*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vc))})`;
  const p=$('p2'), vp=win(t,K.p2,T.locked,BOUNCE), laugh=t>=8.72&&t<9.36?Math.sin((t-8.72)*26)*4:0;
  if(show(p,clamp(vp*2)))p.style.transform=`translate(70px,${f2(640+laugh)}px) rotate(${f2(-6+laugh*0.8+2*Math.sin(t*2))}deg) scale(${f2(Math.max(0.001,vp))})`;
  const b=$('bag'), vb=win(t,K.p2+0.12,T.locked,BOUNCE);
  if(show(b,clamp(vb*2)))b.style.transform=`translate(${f2(180)}px,${f2(700+6*Math.sin(t*4))}px) rotate(${f2(-12+6*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vb))})`;
}
// ---------- locked: "บัญชีหุ้น / เปิดเองไม่ได้" -> "ต้องอายุ 20" + 8/20 bar ----------
function lockF(t){
  const c=$('lockc'), v=win(t,T.locked,T.gold,BOUNCE); if(!show(c,clamp(v*1.6)))return;
  c.style.transform=`translateY(${f2(60*(1-clamp(v))+6*Math.sin(t*1.9))}px) rotate(${f2(0.7*Math.sin(t*1.2))}deg) scale(${f2(Math.max(0.001,0.85+0.15*v))})`;
  const sh=t>=K.maidai&&t<K.maidai+0.6?14*Math.sin((t-K.maidai)*40)*Math.exp(-(t-K.maidai)*5):0;
  const jump=t>=K.yeesib&&t<K.yeesib+0.8?0.25*Math.exp(-(t-K.yeesib)*5)*Math.cos((t-K.yeesib)*14):0;
  $('lockIc').style.transform=`rotate(${f2(sh)}deg) scale(${f2(1+jump)})`;
  $('lockIc').style.background=t>=K.maidai?mix(YEL,RED,clamp((t-K.maidai)/0.15)):YEL;
  const m=t>=T.age20?S(t-T.age20,15,0.84):0;
  $('lt1').style.opacity=f2(1-clamp(m*2.5)); $('lt1').style.transform=`translateY(${f2(-30*m)}px)`;
  const s1=t>=K.maidai?S(t-K.maidai,POP[0],POP[1]):0; $('ls1').style.opacity=f2(clamp(s1)*(1-clamp(m*2.5)));
  $('ls1').style.transform=`scale(${f2(Math.max(0.001,s1))})`;
  $('lt2').style.opacity=f2(clamp(m*2.5-0.5)); $('lt2').style.transform=`translateY(${f2(30*(1-m))}px)`;
  const n=t>=K.yeesib?S(t-K.yeesib,POP[0],POP[1]):0; $('l20').style.transform=`scale(${f2(1+0.5*Math.max(0,1-n)*(t>=K.yeesib?1:0))})`;
  const b=t>=K.ayu?S(t-K.ayu,12,0.85):0; $('ageTr').style.opacity=f2(clamp((t-T.age20-0.05)/0.12));
  $('ageFill').style.width=f2(Math.max(0,520*0.4*b))+'px'; $('atk8').style.transform=`translateX(${f2(lerp(0,196,clamp(b)))}px)`;
}
// ---------- speech bubbles (pestering mom / dad / both again) ----------
function bubble(id,a,b,x,y,t,i=0){const e=$(id), v=win(t,a,b,BOUNCE); if(!show(e,clamp(v*2)))return;
  const nag=0.05*Math.max(0,Math.sin((t-a)*7.5+i)); e.style.transform=`translate(${f2(x)}px,${f2(y+5*Math.sin(t*3+i))}px) rotate(${f2((i%2?2:-2)+2*Math.sin(t*4+i))}deg) scale(${f2(Math.max(0.001,v)*(1+nag))})`;}
function bubbles(t){
  bubble('bubM',K.tuemae,T.gold_price,140,640,t,0);
  bubble('bubD',K.onpor,T.set_price,120,620,t,1);
  bubble('bP',K.tue2,T.crash,170,650,t,0); bubble('bMo',K.tue2+0.2,T.crash,600,760,t,1);
  const a=$('again'), va=win(t,K.rob,T.crash,POP);
  if(show(a,clamp(va*2)))a.style.transform=`translateY(${f2(900)}px) rotate(${f2(-8+2*Math.sin(t*5))}deg) scale(${f2(Math.max(0.001,0.4+0.6*va))})`;
}
// ---------- price card: gold (บาทละ 5,000+ -> 60,000+), then SET (269 -> ~1,500); counters stop on sourced numbers only ----------
// research.md: gold 5,426 (2000) / 63,800 (12 Nov 69) -> shown as ranges "5,000+" / "60,000+"; SET 269.19 (end 2000) / 1,499.53 (16 Nov 69) -> "269" / "~1,500"
const PC=[{a:T.gold_price,b:T.stock,ic:'coins',h:'ทองแท่ง · บาทละ',la:'ปี 2000',lb:'พ.ย. 69',f:'ราคาทองแท่ง ณ พ.ย. 69',
   A:[K.baht,K.hapan,0,5000,'5,000+',''],B:[K.tonni,K.hok,5000,60000,'60,000+',''],rA:5426/63800},
  {a:T.set_price,b:T.piggy,ic:'chart-line',h:'ดัชนีหุ้นไทย (SET)',la:'สิ้นปี 2000',lb:'พ.ย. 69',f:'ดัชนี ณ พ.ย. 69 (ประมาณ)',
   A:[K.dat+0.1,K.songroi+0.1,0,269,'269','จุด'],B:[K.tonni2,K.panha,269,1500,'~1,500','จุด'],rA:269.19/1499.53}];
function counter(t,[a,b,v0,v1,fin,unit],step){if(t<a)return {s:fmt(v0),u:unit,done:0}; if(t>=b)return {s:fin,u:unit,done:1};
  return {s:fmt(Math.round(lerp(v0,v1,eo((t-a)/(b-a)))/step)*step),u:unit,done:0};}
function priceF(t){
  const c=$('pc'); let cur=null; PC.forEach(p=>{if(t>=p.a&&t<p.b+0.1)cur=p;}); if(!cur){c.style.opacity='0';return;}
  const v=win(t,cur.a,cur.b,BOUNCE); if(!show(c,clamp(v*1.6)))return;
  c.style.transform=`translateY(${f2(60*(1-clamp(v))+6*Math.sin(t*1.8))}px) rotate(${f2(0.7*Math.sin(t*1.1))}deg) scale(${f2(Math.max(0.001,0.85+0.15*v))})`;
  $('pcUse').setAttribute('href','#ic-'+cur.ic); $('pcHt').textContent=cur.h; $('plA').textContent=cur.la; $('plB').textContent=cur.lb; $('pcF').textContent=cur.f;
  const step=cur.A[3]>1000?100:1, A=counter(t,cur.A,step), B=counter(t,cur.B,cur.B[3]>10000?1000:step);
  const ha=`${A.s}${A.u?`<small>${A.u}</small>`:''}`, hb=`${B.s}${B.u?`<small>${B.u}</small>`:''}`;
  if($('pvA').innerHTML!==ha)$('pvA').innerHTML=ha; if($('pvB').innerHTML!==hb)$('pvB').innerHTML=hb;
  const bA=t>=cur.A[0]?S(t-cur.A[0],12,0.85):0, bB=t>=cur.B[0]?S(t-cur.B[0],10,0.85):0, MAXW=270;
  $('pbA').style.width=f2(Math.max(0,MAXW*cur.rA*bA+8*clamp(bA)))+'px'; $('pbB').style.width=f2(Math.max(0,MAXW*bB))+'px';
  const nowIn=cur===PC[0]?T.gold_now:T.set_now, vb=t>=nowIn?S(t-nowIn,POP[0],POP[1]):0;
  $('prB').style.opacity=f2(clamp(vb*1.5)); $('prB').style.transform=`translateY(${f2(30*(1-clamp(vb)))}px)`; $('pcF').style.opacity=f2(clamp(vb));
  [['pvA',cur.A[1]],['pvB',cur.B[1]]].forEach(([id,k])=>{const d=t-k; $(id).style.transform=`scale(${f2(1+(d>=0&&d<0.8?0.18*Math.exp(-d*6)*Math.cos(d*15):0))})`; $(id).style.transformOrigin='0 60%';});
  const up=t>=cur.B[1]?S(t-cur.B[1],POP[0],POP[1]):0; $('pUp').style.opacity=f2(clamp(up)); $('pUp').style.transform=`translateY(${f2(-8*Math.sin(t*6))}px) scale(${f2(Math.max(0.001,up))})`;
}
// ---------- stock: big up arrow over the green chart ----------
const UPA=el('g',{opacity:0},G);
el('path',{d:'M0 -190 L120 -40 L50 -40 L50 170 L-50 170 L-50 -40 L-120 -40 Z',fill:GRN,stroke:INK,'stroke-width':12,'stroke-linejoin':'round'},UPA);
function upArrow(t){const v=win(t,K.m2,T.set_price,BOUNCE); UPA.setAttribute('opacity',f2(clamp(v*2))); if(v<0.003)return;
  const climb=(t-K.m2)*26; UPA.setAttribute('transform',`translate(790 ${f2(1100-120*clamp(v)-climb)}) rotate(${f2(4*Math.sin(t*3))}) scale(${f2(Math.max(0.001,0.85*v))})`);}
// ---------- bitcoin: appears on "บิตคอยน์", grows in the teen shot ("มีให้ซื้อปี 2010", "ม.ปลาย") ----------
function btcF(t){
  const c=$('btc'), v=win(t,K.btc,T.parents_again,BOUNCE); if(show(c,clamp(v*2))){
    const g=t>=T.teen?S(t-T.teen,15,0.84):0, x=540, y=lerp(700,830,g), s=lerp(0.85,1.35,g)*Math.max(0.001,v);
    const wait=t<T.teen?0.06*Math.sin(t*10):0; c.style.transform=`translate(${f2(x)}px,${f2(y+8*Math.sin(t*3))}px) rotate(${f2(lerp(-10,0,g)+8*Math.sin(t*2))}deg) scale(${f2(s*(1+wait))})`;}
  const l=$('btcL'), vl=win(t,K.sue,T.parents_again,BOUNCE);
  if(show(l,clamp(vl*2)))l.style.transform=`translate(${f2(510-l.offsetWidth/2)}px,${f2(980)}px) rotate(${f2(-2+1.5*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vl))})`;
  const m=$('mpl'), vm=win(t,K.mplai,T.parents_again,BOUNCE);
  if(show(m,clamp(vm*2)))m.style.transform=`translate(${f2(540-m.offsetWidth/2)}px,${f2(600)}px) rotate(${f2(3+2*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,vm))})`;
}
// ---------- crash: the bars stand still in the footage -> a red line drawn falling (d3) + "~90%" + bar shrinking to 1/10 ----------
const CR=[[0,0.32],[0.1,0.18],[0.2,0.24],[0.3,0.08],[0.4,0.2],[0.52,0.55],[0.62,0.5],[0.74,0.8],[0.86,0.86],[1,0.93]];
const crX=x=>150+x*720, crY=y=>620+y*440;
const CRG=el('g',{opacity:0},G);
const crShadow=el('path',{d:d3.line().curve(d3.curveMonotoneX)(CR.map(([x,y])=>[crX(x),crY(y)])),fill:'none',stroke:INK,'stroke-width':30,'stroke-linecap':'round','stroke-linejoin':'round'},CRG);
const crPath=el('path',{d:crShadow.getAttribute('d'),fill:'none',stroke:RED,'stroke-width':16,'stroke-linecap':'round','stroke-linejoin':'round'},CRG);
const crHead=el('circle',{r:22,fill:RED,stroke:INK,'stroke-width':8},CRG);
let crLen=0;
function crashF(t){
  const v=win(t,T.crash,T.hold,OUT); CRG.setAttribute('opacity',f2(v)); if(v>0.003){
    if(!crLen)crLen=crPath.getTotalLength();
    const p=t<K.ruang?0.33*clamp((t-T.crash)/(K.ruang-T.crash)):lerp(0.33,1,eo((t-K.ruang)/0.6));
    [crShadow,crPath].forEach(e=>{e.setAttribute('stroke-dasharray',`${crLen} ${crLen}`); e.setAttribute('stroke-dashoffset',f2(crLen*(1-p)));});
    const pt=crPath.getPointAtLength(crLen*p); crHead.setAttribute('cx',f2(pt.x)); crHead.setAttribute('cy',f2(pt.y));}
  const c=$('crashL'), vc=win(t,K.kao,T.outro,BOUNCE);
  if(show(c,clamp(vc*1.6)))c.style.transform=`translateY(${f2(30*(1-clamp(vc))+5*Math.sin(t*2))}px) rotate(${f2(-2+Math.sin(t*1.5))}deg) scale(${f2(Math.max(0.001,0.8+0.2*vc))})`;
  const s=t>=K.kao+0.1?S(t-K.kao-0.1,10,0.8):0; $('cBar').style.width=f2(360*lerp(1,0.1,clamp(s)))+'px';
}
// ---------- hold: "ถือไหวป่ะ?" shaking (this line is the speech; captions stop here) ----------
function holdF(t){const h=$('holdT'), v=win(t,K.wai,T.outro,BOUNCE); if(!show(h,clamp(v*2)))return;
  const sh=6*Math.sin(t*38); h.style.transform=`translate(${f2(sh-30)}px,${f2(700+3*Math.cos(t*31))}px) rotate(${f2(-4+2*Math.sin(t*5))}deg) scale(${f2(Math.max(0.001,0.5+0.5*v))})`;}
// ---------- outro: comment prompt under the checklist ----------
function outroF(t){const c=$('cmt'), v=win(t,K.tamtang,DUR+1,BOUNCE); if(!show(c,clamp(v*2)))return;
  c.style.transform=`translate(${f2(510-c.offsetWidth/2)}px,${f2(1262)}px) rotate(${f2(-2+1.5*Math.sin(t*3))}deg) scale(${f2(Math.max(0.001,v))})`;}

// ---------- captions: spring in on the word ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0||t>=CEND) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); texture(t); fx(t); titles(t); year(t); hud(t); checklist(t); future(t); kid(t); lockF(t); bubbles(t);
  priceF(t); upArrow(t); btcF(t); crashF(t); holdF(t); outroF(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
