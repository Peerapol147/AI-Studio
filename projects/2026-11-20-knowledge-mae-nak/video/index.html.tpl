<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0B1A24}
#stage{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 40%}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vid{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
.sil{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
/* story backdrops for the graphic shots (no footage): cold night */
.nbg{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 42%,#1D3A44 0%,#10242E 45%,#060D12 100%)}
#paperImg{position:absolute;left:-40px;top:-70px;width:1160px;height:2060px;object-fit:cover}
/* registry: vignette (pure CSS gradient) */
#vig{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:30;pointer-events:none;
  background:radial-gradient(ellipse 75% 62% at 50% 46%,rgba(4,8,12,0) 50%,rgba(4,8,12,.72) 100%)}
#vigP{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:30;pointer-events:none;opacity:0;
  background:radial-gradient(ellipse 80% 66% at 50% 46%,rgba(60,36,16,0) 55%,rgba(60,36,16,.42) 100%)}
/* fog (hand-built: registry search "fog mist drifting" had no fit): soft blobs drifting, parallax front layer */
#fog{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:25;pointer-events:none;overflow:hidden}
#fog div{position:absolute;left:0;top:0;width:1100px;height:560px;border-radius:50%;
  background:radial-gradient(ellipse at 50% 50%,rgba(176,206,210,.34) 0%,rgba(150,186,192,.16) 42%,rgba(150,186,192,0) 70%)}
/* registry: grain-overlay (texture + stepped offsets, driven by timeline time instead of CSS keyframes) */
#grain{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:31;pointer-events:none;overflow:hidden}
#grain .gt{position:absolute;top:-50%;left:-50%;width:200%;height:200%;opacity:.12;
  background:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E")}
/* registry: editorial-flash-overlay layers (wash / core / sweep), adapted to one "lights on" hit */
#flash{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:45;pointer-events:none}
#flash div{position:absolute;opacity:0}
#efWash{left:0;top:0;width:1080px;height:1920px;background:#FFF6E2}
#efCore{left:-200px;top:-340px;width:1480px;height:2600px;mix-blend-mode:screen;
  background:radial-gradient(ellipse 68% 92% at 45% 40%,#fff 0%,rgba(255,250,236,.96) 22%,rgba(255,236,200,.7) 45%,rgba(242,178,92,.25) 67%,rgba(0,0,0,0) 86%)}
#efSweep{left:-300px;top:-540px;width:1680px;height:3000px;mix-blend-mode:screen;
  background:linear-gradient(108deg,rgba(0,0,0,0) 21%,rgba(242,178,92,.1) 38%,rgba(255,246,226,.9) 49%,#fff 53%,rgba(200,230,240,.24) 62%,rgba(0,0,0,0) 79%)}
.ov{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:visible}
#tshade{position:absolute;left:0;top:0;width:1080px;height:900px;background:linear-gradient(rgba(4,9,13,.8) 0%,rgba(4,9,13,.55) 55%,rgba(4,9,13,0) 100%)}
/* hook title (frame 0) */
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:24px #05090C;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
#title .tl em{font-style:normal;color:#FFE14D}
#title #tlS{font-weight:700;color:#CFE3E6;-webkit-text-stroke:14px #05090C}
/* closing question (c1) */
#qend{position:absolute;left:0;top:0;width:1080px;height:760px;opacity:0}
#qend .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;color:#fff;
  -webkit-text-stroke:24px #05090C;paint-order:stroke fill;transform-origin:50% 60%;text-shadow:0 12px 0 rgba(0,0,0,.45)}
#qend .tl em{font-style:normal;color:#FFE14D}
/* h2 kinetic "มาก?" */
#kin{position:absolute;left:0;top:0;width:1080px;height:1100px;opacity:0}
#kin .k1{position:absolute;left:0;top:470px;width:1080px;text-align:center;font-weight:900;font-size:96px;line-height:1;color:#fff;
  -webkit-text-stroke:18px #05090C;paint-order:stroke fill;white-space:nowrap}
#kin .k2{position:absolute;left:0;top:600px;width:1080px;text-align:center;font-weight:900;font-size:260px;line-height:1;color:#FFE14D;
  -webkit-text-stroke:30px #05090C;paint-order:stroke fill;white-space:nowrap;transform-origin:50% 60%;text-shadow:0 16px 0 rgba(0,0,0,.5)}
#kin .k2 b{display:inline-block;color:#fff;transform-origin:50% 80%}
/* whisper (s10) */
#whis{position:absolute;left:0;top:640px;width:1080px;text-align:center;font-weight:700;font-size:92px;color:#BFE6EA;opacity:0;white-space:nowrap;
  -webkit-text-stroke:14px #03080B;paint-order:stroke fill;text-shadow:0 0 30px rgba(140,220,230,.6)}
/* twist: paper + ink */
.ink{color:#3B2414}
#t1h{position:absolute;left:0;top:300px;width:1080px;text-align:center;opacity:0}
#t1h .a{font-weight:900;font-size:136px;line-height:1.05;color:#3B2414;white-space:nowrap}
#t1h .b{font-weight:700;font-size:72px;line-height:1.1;color:#6B4426;white-space:nowrap}
#t1h .b span{display:inline-block}
#desk{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 36%}
#doc{position:absolute;left:150px;top:270px;width:720px;height:560px;border-radius:14px;background:#F8EFD9;opacity:0;
  box-shadow:0 0 0 4px #6B4426,0 0 0 12px rgba(248,239,217,.9),0 0 0 15px #6B4426,0 26px 50px rgba(60,36,16,.35);transform-origin:50% 50%}
#doc .pg{position:absolute;left:0;top:0;width:720px;height:560px}
.mast{position:absolute;left:0;top:34px;width:720px;text-align:center;font-family:'Sarabun';font-weight:700;font-size:92px;line-height:1.1;color:#2E1A0E;white-space:nowrap}
.rule{position:absolute;left:50px;width:620px;height:0;border-top:5px solid #2E1A0E}
.rule2{position:absolute;left:50px;width:620px;height:0;border-top:2px solid #2E1A0E}
.dsub{position:absolute;left:0;top:178px;width:720px;text-align:center;font-family:'Sarabun';font-weight:700;font-size:46px;color:#4A2E1A;white-space:nowrap}
.cols{position:absolute;left:50px;top:256px;width:620px;height:180px}
.cols i{position:absolute;height:12px;border-radius:6px;background:rgba(74,46,26,.28)}
.stamp{position:absolute;left:70px;top:446px;height:84px;padding:0 26px 0 20px;border-radius:16px;border:5px solid #2F6B3A;color:#2F6B3A;background:rgba(248,239,217,.92);
  display:flex;align-items:center;gap:12px;font-weight:700;font-size:44px;white-space:nowrap;transform-origin:20% 50%}
.stamp svg{width:52px;height:52px;color:#2F6B3A}
.small{position:absolute;left:0;top:26px;width:720px;text-align:center;font-family:'Sarabun';font-weight:700;font-size:48px;color:#6B4426;white-space:nowrap}
.bigA{position:absolute;left:0;top:96px;width:720px;text-align:center;font-weight:900;font-size:150px;line-height:1.05;color:#2E1A0E;white-space:nowrap}
.bigA em{font-style:normal;color:#8A3B12}
.subA{position:absolute;left:0;top:276px;width:720px;text-align:center;font-weight:700;font-size:70px;color:#4A2E1A;white-space:nowrap}
.lab{position:absolute;left:70px;top:120px;font-weight:700;font-size:56px;color:#6B4426;white-space:nowrap}
#chum{position:absolute;left:0;top:150px;width:720px;text-align:center;font-weight:900;font-size:220px;line-height:1;color:#2E1A0E;white-space:nowrap;transform-origin:50% 60%}
#makC{position:absolute;left:0;top:0;font-weight:900;font-size:96px;line-height:1;color:#7A6A58;white-space:nowrap;transform-origin:50% 50%}
.tag{position:absolute;left:0;top:0;height:96px;padding:0 30px 0 22px;border-radius:48px;border:5px dashed #8A4B12;background:#F3E3BF;color:#8A4B12;
  display:flex;align-items:center;gap:12px;font-weight:900;font-size:56px;white-space:nowrap;opacity:0;transform-origin:0 50%}
.tag svg{width:56px;height:56px;color:#8A4B12}
#stageCard{position:absolute;left:0;top:0;width:430px;height:430px;border-radius:12px;overflow:hidden;opacity:0;
  box-shadow:0 0 0 6px #F8EFD9,0 0 0 10px #6B4426,0 20px 40px rgba(60,36,16,.4)}
.vcard{position:absolute;left:0;top:0;width:430px;height:430px;object-fit:cover}
#stageLab{position:absolute;left:0;top:0;font-weight:900;font-size:58px;color:#3B2414;white-space:nowrap;opacity:0}
#q8{position:absolute;left:0;top:300px;width:1080px;text-align:center;font-weight:900;font-size:110px;line-height:1.1;color:#3B2414;white-space:nowrap;opacity:0;transform-origin:50% 60%}
#q8 em{font-style:normal;color:#8A3B12}
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
<radialGradient id="warm"><stop offset="0" stop-color="#F2B25C" stop-opacity=".85"/><stop offset=".35" stop-color="#F2B25C" stop-opacity=".35"/><stop offset="1" stop-color="#F2B25C" stop-opacity="0"/></radialGradient>
<radialGradient id="limeG" cx=".38" cy=".34"><stop offset="0" stop-color="#D8F27A"/><stop offset=".6" stop-color="#8CC63F"/><stop offset="1" stop-color="#4E8A1E"/></radialGradient>
<radialGradient id="moonG"><stop offset="0" stop-color="#8DB7BE" stop-opacity=".42"/><stop offset=".55" stop-color="#6E9AA3" stop-opacity=".18"/><stop offset="1" stop-color="#6E9AA3" stop-opacity="0"/></radialGradient>
<linearGradient id="winG" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFD58A"/><stop offset="1" stop-color="#E98F3A"/></linearGradient>
</defs></svg>

<div id="stage" data-layout-allow-overflow data-layout-allow-overlap>
<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sh-h1"><div class="kb" id="kb-h1">%%V_H1%%<svg class="sil" id="sv-h1" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-h2"><div class="kb" id="kb-h2">%%V_H2%%</div></div>
  <div class="sc" id="sh-s1"><div class="kb" id="kb-s1">%%V_S1%%</div></div>
  <div class="sc" id="sh-s2"><div class="kb" id="kb-s2">%%V_S2%%</div></div>
  <div class="sc" id="sh-s3"><div class="kb" id="kb-s3">%%V_S3%%<svg class="sil" id="sv-s3" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s4"><div class="kb" id="kb-s4">%%V_S4%%<svg class="sil" id="sv-s4" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s5"><div class="kb" id="kb-s5">%%V_S5%%<svg class="sil" id="sv-s5" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s6"><div class="kb" id="kb-s6">%%V_S6%%</div></div>
  <div class="sc" id="sh-s7"><div class="kb" id="kb-s7">%%V_S7%%</div></div>
  <div class="sc" id="sh-s8"><div class="kb" id="kb-s8">%%V_S8%%</div></div>
  <div class="sc" id="sh-s9"><div class="kb" id="kb-s9">%%V_S9%%<svg class="sil" id="sv-s9" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s10"><div class="kb" id="kb-s10">%%V_S10%%<svg class="sil" id="sv-s10" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s11"><div class="kb" id="kb-s11">%%V_S11%%</div></div>
  <div class="sc" id="sh-s12"><div class="kb" id="kb-s12">%%V_S12%%</div></div>
  <div class="sc" id="sh-s13"><div class="nbg"></div><div class="kb" id="kb-s13"><svg class="sil" id="sv-s13" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s14"><div class="kb" id="kb-s14">%%V_S14%%<svg class="sil" id="sv-s14" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s15"><div class="kb" id="kb-s15">%%V_S15%%<svg class="sil" id="sv-s15" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s16"><div class="nbg" style="background:radial-gradient(ellipse at 50% 38%,#163039 0%,#0A161C 50%,#030608 100%)"></div><div class="kb" id="kb-s16"><svg class="sil" id="sv-s16" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s17"><div class="nbg" style="background:radial-gradient(ellipse at 62% 30%,#2A4A54 0%,#14262E 40%,#060D12 100%)"></div><div class="kb" id="kb-s17"><svg class="sil" id="sv-s17" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-s18"><div class="kb" id="kb-s18">%%V_S18%%<svg class="sil" id="sv-s18" viewBox="0 0 1080 1920"></svg></div></div>
  <div class="sc" id="sh-t1"><div class="kb" id="kb-t1">%%V_T1%%</div></div>
  <div class="sc" id="sh-desk"><div id="desk">
    <img id="paperImg" src="assets/paper.jpg" alt=""/>
    <svg class="sil" id="sv-desk" viewBox="0 0 1080 1920"></svg>
    <div id="doc">
      <div class="pg" id="docA"><div class="mast">สยามประเภท</div><div class="rule" style="top:160px"></div><div class="rule2" style="top:170px"></div>
        <div class="dsub">หนังสือพิมพ์ · พ.ศ. 2442</div><div class="rule2" style="top:240px"></div>
        <div class="cols"><i style="left:0;top:10px;width:290px"></i><i style="left:0;top:40px;width:270px"></i><i style="left:0;top:70px;width:290px"></i><i style="left:0;top:100px;width:220px"></i><i style="left:0;top:130px;width:280px"></i>
          <i style="left:330px;top:10px;width:290px"></i><i style="left:330px;top:40px;width:260px"></i><i style="left:330px;top:70px;width:290px"></i><i style="left:330px;top:100px;width:240px"></i><i style="left:330px;top:130px;width:270px"></i></div>
      </div>
      <div class="pg" id="docB"><div class="small">สยามประเภท · 2442</div><div class="bigA">นาก <em>=</em></div><div class="subA">ลูกสาวขุนศรี</div></div>
      <div class="pg" id="docC"><div class="small">สยามประเภท · 2442</div><div class="lab">ผัว</div><div id="chum">ชุ่ม</div></div>
      <div class="stamp" id="stamp"><svg class="ic"><use href="#ic-circle-check"/></svg>ฉบับเขียนเก่าสุดที่พบ</div>
    </div>
    <svg class="sil" id="sv-tl" viewBox="0 0 1080 1920"></svg>
    <div id="makC">มาก</div>
    <div id="stageCard">%%V_T5%%</div><div id="stageLab">ละครร้อง</div>
    <div class="tag" id="tagW"><svg class="ic"><use href="#ic-triangle-alert"/></svg>ว่ากันว่า</div>
    <div class="tag" id="tagB"><svg class="ic"><use href="#ic-book-open"/></svg>บางตำรา</div>
    <div id="q8">มาจาก<em>ฉบับไหน?</em></div>
    <svg class="sil" id="sv-desk2" viewBox="0 0 1080 1920"></svg>
  </div></div>
  <div class="sc" id="sh-c1"><div class="kb" id="kb-c1">%%V_C1%%<svg class="sil" id="sv-c1" viewBox="0 0 1080 1920"></svg></div></div>
</div>
<div id="fog" data-layout-allow-overflow data-layout-allow-overlap><div></div><div></div><div></div><div></div><div></div></div>
<div id="vig"></div><div id="vigP"></div>
<div id="grain" data-layout-allow-overflow><div class="gt" id="gt"></div></div>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:40">
  <div id="t1h"><div class="a">ฉบับเขียน</div><div class="b"><span id="t1b1">เก่าสุด</span> <span id="t1b2">ที่เจอ</span></div></div>
  <div id="whis">“อยู่กับผี...”</div>
  <div id="kin"><div class="k1">ไม่ได้ชื่อ</div><div class="k2" id="k2">มาก<b id="k2q">?</b></div></div>
  <div id="tshade"></div>
  <div id="title"><div class="tl" id="tl1">ผัวแม่นาค</div><div class="tl" id="tlS">ในฉบับเก่าสุด...</div><div class="tl" id="tl2">ไม่ได้ชื่อ ‘<em>มาก</em>’?</div></div>
  <div id="qend"><div class="tl" id="q1">ผัวแม่นาค</div><div class="tl" id="q2"><em>ชื่ออะไร?</em></div></div>
</div>
</div>
<div id="flash"><div id="efWash"></div><div id="efCore"></div><div id="efSweep"></div></div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.1" src="assets/music-jamendo-a573d9da.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine, from the brainrot-v2 template). Shot times = assets/audio/shots-th.json,
   word anchors = words.json (both injected by build_index.py). Story (h1-s18, c1): cold night, footage pushes in slowly,
   fog dissolves (crossfade 0.12 s under a fog surge), silhouettes are drawn shapes (no actors, no faces).
   Twist (t1-t8b): "lights on" flash -> one paper desk where ONE document card morphs (2442 paper -> นาก -> ชุ่ม),
   one timeline grows, and tags ว่ากันว่า / บางตำรา mark the ⚠️ claims. Everything is a function of t. */
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
const MORPH=[15,0.84],FAST=[26,0.8],SLOW=[8,0.95],BOUNCE=[18,0.55],POP=[22,0.5],OUT=[30,1],SOFT=[10,1];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mix=(a,b,u)=>{const x=hex(a),y=hex(b);return `rgb(${x.map((v,i)=>Math.round(lerp(v,y[i],clamp(u)))).join(',')})`;};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const show=(e,o)=>{e.style.opacity=o<0.003?'0':o.toFixed(4);return o>=0.003;};
const f2=v=>v.toFixed(2);
const win=(t,a,b,sp=POP)=>{if(t<a||t>=b+0.1)return 0; const i=S(t-a,sp[0],sp[1]); const o=t>b?1-clamp((t-b)/0.08):1; return Math.max(0,i)*o;};
const fade=(t,a,b,fi=0.15,fo=0.1)=>(t<a||t>=b+fo)?0:clamp((t-a)/fi)*(t>b?1-clamp((t-b)/fo):1);
const SIL='#03070A', RIM='rgba(160,205,214,.3)', INKC='#3B2414', INKL='#6B4426';
const sv=id=>$('sv-'+id);
const TW=T.t1_paper, TD=T.t2_doc, TC=T.c1_loop;

// ---------- silhouette builder (feet at 0,0; height ~500 at s=1; facing +x when profile) ----------
function person(parent,o){
  const g=el('g',{},parent), F=o.fill||SIL, st=o.stroke||RIM, sw=o.sw||3;
  const P=(d,par=g)=>el('path',{d,fill:F,stroke:st,'stroke-width':sw,'stroke-linejoin':'round','stroke-dasharray':o.dash||'none'},par);
  const r={g};
  if(o.lower==='legs'){
    r.legs=[-1,1].map(sx=>{const lg=el('g',{transform:`translate(${sx*16} -215)`},g); P('M-15 0 L15 0 L13 205 L-13 205 Z',lg); P('M-14 200 L22 200 L22 215 L-14 215 Z',lg); return lg;});
  } else P('M-44 -212 L44 -212 C50 -130 56 -50 62 0 L-62 0 C-56 -50 -50 -130 -44 -212 Z');
  P('M-16 -418 L16 -418 C44 -404 58 -380 56 -330 L46 -256 C44 -236 44 -222 46 -206 L-46 -206 C-44 -222 -44 -236 -46 -256 L-56 -330 C-58 -380 -44 -404 -16 -418 Z');
  if(o.belly){ r.belly=el('g',{transform:'translate(40 -258)'},g); el('ellipse',{cx:0,cy:0,rx:44,ry:58,fill:F,stroke:st,'stroke-width':sw},r.belly); }
  r.arms=[-1,1].map(sx=>{const ag=el('g',{transform:`translate(${sx*50} -388)`},g); P(`M${-sx*4} 0 C${sx*12} 50 ${sx*14} 110 ${sx*8} 176 L${-sx*10} 176 C${-sx*8} 110 ${-sx*12} 60 ${-sx*14} 8 Z`,ag); return ag;});
  if(o.baby){ r.baby=el('g',{transform:'translate(26 -318)'},g); el('ellipse',{cx:0,cy:0,rx:50,ry:30,fill:F,stroke:st,'stroke-width':sw},r.baby); el('circle',{cx:34,cy:-26,r:22,fill:F,stroke:st,'stroke-width':sw},r.baby); }
  r.head=el('g',{transform:'translate(0 -458)'},g);
  el('ellipse',{cx:0,cy:0,rx:31,ry:37,fill:F,stroke:st,'stroke-width':sw,'stroke-dasharray':o.dash||'none'},r.head);
  if(o.hair==='long'){ r.hair=el('path',{d:'M-30 -18 C-44 30 -56 120 -64 228 C-40 240 -8 236 14 222 C20 140 30 40 30 -16 C20 -40 -20 -42 -30 -18 Z',fill:F,stroke:st,'stroke-width':sw},r.head); }
  else if(o.hair==='bun'){ el('circle',{cx:-30,cy:-22,r:20,fill:F,stroke:st,'stroke-width':sw},r.head); }
  r.g.setAttribute('opacity',o.op==null?1:o.op);
  return r;
}
const place=(r,x,y,s,flip)=>r.g.setAttribute('transform',`translate(${f2(x)} ${f2(y)}) scale(${(flip?-s:s).toFixed(4)} ${s.toFixed(4)})`);
function glow(parent,x,y,rad){return el('circle',{cx:x,cy:y,r:rad,fill:'url(#warm)'},parent);}
function lime(parent){const g=el('g',{},parent); el('ellipse',{cx:0,cy:0,rx:46,ry:42,fill:'url(#limeG)',stroke:'#2E5212','stroke-width':5},g);
  el('circle',{cx:44,cy:-4,r:6,fill:'#6FA22E',stroke:'#2E5212','stroke-width':3},g); el('ellipse',{cx:-14,cy:-16,rx:12,ry:7,fill:'#F4FFD0',opacity:.7},g); return g;}

// ---------- scenes ----------
// entries: none | fog (0.12 s crossfade under a fog surge) | cut (hard) | flash (hard, under the lights-on flash) | zoom (zoom punch-in, 0.1 s)
const SC=[
 {id:'sh-h1',a:0,kb:'kb-h1',in:'none',hook:1,org:'50% 45%'},
 {id:'sh-h2',a:T.h2_name,kb:'kb-h2',s0:1.04,s1:1.10,r0:0,r1:0,org:'50% 40%',in:'fog'},
 {id:'sh-s1',a:T.s1_moon,kb:'kb-s1',s0:1.02,s1:1.10,r0:-0.5,r1:0.4,org:'50% 25%',in:'fog'},
 {id:'sh-s2',a:T.s2_khlong,kb:'kb-s2',s0:1.03,s1:1.11,r0:0.4,r1:-0.4,org:'30% 40%',in:'fog'},
 {id:'sh-s3',a:T.s3_couple,kb:'kb-s3',s0:1.02,s1:1.10,r0:-0.4,r1:0.4,org:'45% 65%',in:'fog'},
 {id:'sh-s4',a:T.s4_soldier,kb:'kb-s4',s0:1.03,s1:1.12,r0:0.4,r1:-0.3,org:'52% 55%',in:'fog'},
 {id:'sh-s5',a:T.s5_pregnant,kb:'kb-s5',s0:1.03,s1:1.11,r0:-0.4,r1:0.3,org:'55% 65%',in:'fog'},
 {id:'sh-s6',a:T.s6_candle,kb:'kb-s6',s0:1.04,s1:1.12,r0:0.3,r1:-0.3,org:'50% 45%',in:'fog'},
 {id:'sh-s7',a:T.s7_out,kb:'kb-s7',s0:1.06,s1:1.16,r0:0,r1:0,org:'50% 45%',in:'cut'},
 {id:'sh-s8',a:T.s8_boat,kb:'kb-s8',s0:1.03,s1:1.11,r0:-0.4,r1:0.4,org:'50% 55%',in:'fog'},
 {id:'sh-s9',a:T.s9_wait,kb:'kb-s9',s0:1.03,s1:1.12,r0:0.3,r1:-0.3,org:'50% 45%',in:'fog'},
 {id:'sh-s10',a:T.s10_neigh,kb:'kb-s10',s0:1.02,s1:1.10,r0:-0.4,r1:0.4,org:'50% 55%',in:'fog'},
 {id:'sh-s11',a:T.s11_nope,kb:'kb-s11',s0:1.03,s1:1.10,r0:0,r1:0,org:'50% 50%',in:'cut'},
 {id:'sh-s12',a:T.s12_mortar,kb:'kb-s12',s0:1.04,s1:1.12,r0:0.6,r1:-0.6,org:'50% 60%',in:'cut'},
 {id:'sh-s13',a:T.s13_lime,kb:'kb-s13',s0:1.0,s1:1.08,r0:0,r1:0,org:'55% 50%',in:'cut'},
 {id:'sh-s14',a:T.s14_under,kb:'kb-s14',s0:1.05,s1:1.16,r0:-0.5,r1:0.5,org:'45% 70%',in:'fog'},
 {id:'sh-s15',a:T.s15_arm,kb:'kb-s15',s0:1.02,s1:1.12,r0:0.4,r1:-0.6,org:'50% 40%',in:'fog'},
 {id:'sh-s16',a:T.s16_eye,kb:'kb-s16',s0:1.0,s1:1.14,r0:0,r1:0,org:'50% 37%',in:'cut'},
 {id:'sh-s17',a:T.s17_temple,kb:'kb-s17',s0:1.04,s1:1.14,r0:-0.5,r1:0.5,org:'50% 60%',in:'fog'},
 {id:'sh-s18',a:T.s18_rampage,kb:'kb-s18',s0:1.04,s1:1.12,r0:0.8,r1:-0.8,org:'50% 45%',in:'fog'},
 {id:'sh-t1',a:TW,kb:'kb-t1',s0:1.02,s1:1.08,r0:-0.6,r1:0.3,org:'50% 30%',in:'flash'},
 {id:'sh-desk',a:TD,in:'zoom'},
 {id:'sh-c1',a:TC,kb:'kb-c1',in:'fog',loop:1,org:'50% 45%'},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; $(s.id).style.zIndex=String(i+1); if(s.kb)$(s.kb).style.transformOrigin=s.org;});
const XF=0.12;
const FOGCUTS=SC.filter(s=>s.in==='fog').map(s=>s.a);
function sceneState(s,t){
  if(t<s.a)return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,sc=1;
  if(s.in==='fog'){ o=eio(u/XF); }
  else if(s.in==='zoom'){ o=eio(u/0.1); sc=1+0.25*(1-S(u,18,0.9)); }
  if(nx){
    if(nx.in==='cut'||nx.in==='flash'){ if(t>=end)return null; }
    else { if(t>=end+XF)return null; if(nx.in==='zoom'&&t>end-0.1) sc*=1+0.4*ei((t-end+0.1)/0.22); }
  }
  return {o,sc};
}
const hookPunch=t=>0.09*S(t-K.maenak,9,0.9);   // first image change at "แม่นาค" (0.30 s): push-in on the canal
function scenes(t){
  SC.forEach(s=>{const r=sceneState(s,t), e=$(s.id);
    if(!r){e.style.opacity='0';return;}
    e.style.opacity=r.o.toFixed(4); e.style.transform=`scale(${r.sc.toFixed(4)})`;
    if(!s.kb)return;
    const uu=clamp((t-s.a)/Math.max(0.3,(s.b-s.a)));
    if(s.hook){ $(s.kb).style.transform=`scale(${(1+hookPunch(t)+0.03*uu).toFixed(5)})`; return; }
    if(s.loop){ const k=lerp(1.12,1.0,eio(uu)); $(s.kb).style.transform=`scale(${k.toFixed(5)})`; return; }   // ends at 1.00 = frame 0
    const k=lerp(s.s0,s.s1,uu), rr=lerp(s.r0,s.r1,uu), dx=8*Math.sin(t*0.9+s.a), dy=6*Math.cos(t*0.7+s.a);
    $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`;
  });
}
const story=t=>t<TW||t>=TC;   // night look on

// ---------- fog, grain, vignette, flash ----------
const FOG=[...$('fog').children].map((e,i)=>({e,i,y:[240,760,1080,1380,520][i],sp:[26,-18,34,-22,14][i],sc:[1.3,1.0,1.5,1.2,0.9][i]}));
function atmos(t){
  const twist=t>=TW&&t<TC, inT5b=t>=T.t5b_some&&t<T.t6_boy+0.4;
  let surge=0; FOGCUTS.forEach(c=>{const d=t-c; surge+=0.8*Math.exp(-Math.abs(d)/0.13);});
  const base=twist?(inT5b?0.55*fade(t,T.t5b_some,T.t6_boy,0.4,0.4):0):(t<TC?0.62:0.62*clamp((t-TC)/0.3)+0);
  const storm=(t>=T.s18_rampage&&t<TW)?2.4:1;
  FOG.forEach(f=>{const x=((f.sp*storm*t+f.i*330)%1500+1500)%1500-700, y=f.y+30*Math.sin(t*0.4+f.i);
    f.e.style.transform=`translate(${f2(x)}px,${f2(y)}px) scale(${f.sc},${(f.sc*0.8).toFixed(3)})`;
    f.e.style.opacity=f2(clamp(base*(0.7+0.3*Math.sin(t*0.6+f.i))+(twist?0:surge*(0.6+0.1*f.i))));
    f.e.style.filter=twist?'sepia(1) saturate(1.6) brightness(.8)':'none';});
  const gi=Math.floor(t*12), gx=((gi*37)%21)-10, gy=((gi*53)%21)-10;
  $('gt').style.transform=`translate(${gx}%,${gy}%)`; $('gt').style.opacity=twist?'0.07':'0.12';
  show($('vig'),twist?0:1); show($('vigP'),twist?1:0);
  // lights-on flash (registry editorial-flash-overlay timing: wash in 0.04 s, out 0.18 s; core and sweep follow)
  const u=t-TW; const w=u<0?0:(u<0.05?ei(u/0.05)*0.95:0.95*(1-eo((u-0.05)/0.24)));
  $('efWash').style.opacity=f2(Math.max(0,w));
  const c=u<0||u>0.5?0:(u<0.05?u/0.05:1-eo((u-0.05)/0.4)); $('efCore').style.opacity=f2(c); $('efCore').style.transform=`scale(${f2(0.86+0.3*clamp(u/0.45))})`;
  const sw=u<0||u>0.42?0:Math.sin(Math.PI*clamp(u/0.42)); $('efSweep').style.opacity=f2(0.9*sw); $('efSweep').style.transform=`translateX(${f2(-30+60*clamp(u/0.42))}%)`;
  // closing: lights back off (dark dip into the canal)
}

// ---------- hook title: complete at frame 0 (no fade-in), breathes 1.0<->1.04; back in the last ~0.3 s (loop) ----------
const TL=[['tl1',250,176],['tlS',448,62],['tl2',540,124]];
TL.forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
[['q1',300,170],['q2',486,170]].forEach(([id,y,s])=>{$(id).style.top=y+'px'; $(id).style.fontSize=s+'px';});
const TBACK=DUR-0.3, BRP=DUR/40;   // breathing period divides DUR -> phase at the end = phase at frame 0
const br=t=>1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/BRP));
function title(t){
  let o,sc;
  if(t<TBACK){ const out=eo((t-(T.h2_name-0.04))/0.12); o=1-out; sc=1+0.2*out; }
  else { const a=S(t-TBACK,26,0.8); o=clamp(a*1.4); sc=1+0.1*(1-a); }
  show($('title'),o);
  const qv=t>=K.phua3&&t<TBACK+0.12?clamp(S(t-K.phua3,18,0.7))*(t>TBACK?1-clamp((t-TBACK)/0.12):1):0;
  show($('tshade'),Math.max(t<TBACK?o:1,qv));
  show($('qend'),qv);
  [['q1',0],['q2',1]].forEach(([id,i])=>{$(id).style.transform=`translateY(${f2(30*(1-clamp(qv))+3*Math.sin(t*2.4+i))}px) scale(${(br(t)*(0.85+0.15*qv)).toFixed(4)})`;});
  const live=t<TBACK?1:0;
  TL.forEach(([id],i)=>{$(id).style.transform=`translateY(${f2(live*3*Math.sin(t*2*Math.PI/BRP+i))}px) scale(${((t<TBACK?br(t):1)*sc).toFixed(4)})`;});
}

// ---------- h1 / c1: woman with long hair on the landing (same pose both, so the last frame = frame 0) ----------
function landing(id){
  const s=sv(id), g=el('g',{},s);
  el('rect',{x:120,y:1328,width:300,height:22,fill:'#071015',stroke:RIM,'stroke-width':2},g);
  [150,250,380].forEach(x=>el('rect',{x,y:1340,width:14,height:110,fill:'#060D11'},g));
  const w=person(g,{hair:'long'}); place(w,262,1330,0.92,true); return w;
}
const W1=landing('h1'), WC=landing('c1');
function hairSway(w,t){ w.hair.setAttribute('transform',`skewX(${f2(4*Math.sin(t*2*Math.PI/BRP*0.5))})`); }

// ---------- h2: kinetic "มาก?" ----------
function kin(t){
  const a=T.h2_name, b=T.s1_moon, v=win(t,a,b,FAST); if(!show($('kin'),clamp(v*1.6)))return;
  const m=t>=K.mak?S(t-K.mak,16,0.5):0;
  $('k2').style.opacity=f2(clamp(m*1.5)); $('k2').style.transform=`scale(${f2(Math.max(0.001,0.4+0.6*m))}) rotate(${f2(-3*(1-clamp(m))+1.2*Math.sin(t*3))}deg)`;
  $('k2q').style.transform=`rotate(${f2(14*Math.sin(t*6))}deg)`;
  $('kin').querySelector('.k1').style.transform=`translateY(${f2(-20*clamp(m))}px)`;
}

// ---------- s3 couple / s4 soldier / s5 pregnant / s9 window / s10 neighbours ----------
const C3=sv('s3'), lamp3=glow(C3,640,1225,170); el('rect',{x:628,y:1192,width:24,height:36,rx:4,fill:'#F2B25C',stroke:'#2a1a08','stroke-width':3},C3);
const man3=person(C3,{lower:'legs'}), wom3=person(C3,{hair:'long'});
const C4=sv('s4'), man4=person(C4,{lower:'legs'}), wom4=person(C4,{hair:'long'});
const spear=el('path',{d:'M0 0 L0 -330',stroke:SIL,'stroke-width':10,'stroke-linecap':'round'},man4.g); spear.setAttribute('transform','translate(-40 -380) rotate(-14)');
const C5=sv('s5'), lamp5=glow(C5,330,1260,190); el('rect',{x:318,y:1226,width:24,height:36,rx:4,fill:'#F2B25C',stroke:'#2a1a08','stroke-width':3},C5);
const preg=person(C5,{hair:'bun',belly:1});
const C9=sv('s9'), WIN=el('g',{},C9);
const winGlow=glow(WIN,540,860,330);
el('rect',{x:380,y:660,width:320,height:390,rx:6,fill:'url(#winG)',stroke:'#1a0f06','stroke-width':16},WIN);
const clipW=el('clipPath',{id:'cw'},C9); el('rect',{x:388,y:668,width:304,height:374},clipW);
const mg=el('g',{'clip-path':'url(#cw)'},WIN); const mom=person(mg,{hair:'long',baby:1,stroke:'none'});
el('rect',{x:372,y:880,width:336,height:16,fill:'#1a0f06'},WIN); el('rect',{x:532,y:660,width:16,height:390,fill:'#1a0f06'},WIN);
el('rect',{x:360,y:1040,width:360,height:30,fill:'#120a05'},WIN);
const C10=sv('s10'), nb1=person(C10,{hair:'bun'}), nb2=person(C10,{lower:'legs'});
function people(t){
  // s3: the couple drifts together, lantern flickers
  const a3=T.s3_couple, k3=S(t-T.s3_couple,4,1)*0+clamp((t-a3)/2.3), lean=t>=K.rak?S(t-K.rak,8,0.8):0;
  place(man3,lerp(400,425,k3),1250,0.8,false); place(wom3,lerp(520,488,k3),1250,0.74,true);
  wom3.head.setAttribute('transform',`translate(0 -458) rotate(${f2(-8*lean)})`); man3.head.setAttribute('transform',`translate(0 -458) rotate(${f2(6*lean)})`);
  lamp3.setAttribute('r',f2(160+14*Math.sin(t*9)+8*Math.sin(t*23)));
  // s4: man walks away towards the gate (back view), she watches
  const u4=clamp((t-T.s4_soldier)/1.9), s4=lerp(0.95,0.5,u4);
  place(man4,lerp(600,560,u4),lerp(1400,1060,u4),s4,false);
  man4.legs.forEach((l,i)=>l.setAttribute('transform',`translate(${(i?16:-16)} -215) rotate(${f2((i?1:-1)*16*Math.sin(t*7))})`));
  man4.arms.forEach((ag,i)=>ag.setAttribute('transform',`translate(${(i?50:-50)} -388) rotate(${f2((i?-1:1)*10*Math.sin(t*7))})`));
  place(wom4,170,1420,1.25,true); hairSway(wom4,t);
  // s5: belly grows on "ท้องแก่", hand on it
  const bl=t>=K.thong?S(t-K.thong,9,0.7):0.6;
  place(preg,640,1300,0.95,false); preg.belly.setAttribute('transform',`translate(40 -258) scale(${f2(0.75+0.35*bl)})`);
  preg.arms[1].setAttribute('transform',`translate(50 -388) rotate(${f2(-24*clamp(bl))})`);
  lamp5.setAttribute('r',f2(180+12*Math.sin(t*8)+6*Math.sin(t*21)));
  // s9: mother rocks the baby in the lit window
  place(mom,560+6*Math.sin(t*2.2),1290,0.95,false); mom.g.setAttribute('transform',mom.g.getAttribute('transform')+` rotate(${f2(2*Math.sin(t*2.2))})`);
  winGlow.setAttribute('r',f2(320+18*Math.sin(t*7)));
  // s10: two neighbours lean in and whisper
  const lw=t>=K.phi?S(t-K.phi,10,0.7):0;
  place(nb1,lerp(150,190,lw),1500,1.25,true); place(nb2,lerp(870,830,lw),1520,1.3,false);
  nb1.head.setAttribute('transform',`translate(0 -458) rotate(${f2(10*lw)})`); nb2.head.setAttribute('transform',`translate(0 -458) rotate(${f2(-10*lw)})`);
  const wv=win(t,K.phi,T.s11_nope,SOFT); if(show($('whis'),clamp(wv)*(0.85+0.15*Math.sin(t*5))))
    $('whis').style.transform=`translate(${f2(4*Math.sin(t*11))}px,${f2(-20*clamp(wv))}px) scale(${f2(0.9+0.1*wv)})`;
  hairSway(W1,t); hairSway(WC,t); hairSway(wom3,t+1);
}

// ---------- s13 lime rolls and drops through the floor gap ("มะนาวตก") ----------
const C13=sv('s13');
el('rect',{x:-100,y:960,width:1300,height:900,fill:'#04090C'},C13);
[[-100,560],[700,520]].forEach(([x,w])=>el('rect',{x,y:880,width:w,height:80,fill:'#3A2616',stroke:'#1B1009','stroke-width':6},C13));
[[-100,90],[160,120],[420,140],[740,130],[980,200]].forEach(([x,w])=>el('rect',{x,y:880,width:w,height:80,fill:'none',stroke:'#24170C','stroke-width':4},C13));
[180,560,860].forEach(x=>el('rect',{x,y:960,width:40,height:520,fill:'#0A1217'},C13));
const mortar13=el('g',{transform:'translate(200 880)'},C13);
el('path',{d:'M-90 0 L-70 -120 L70 -120 L90 0 Z',fill:'#20262A',stroke:'#0D1012','stroke-width':6},mortar13);
el('rect',{x:-10,y:-250,width:28,height:160,rx:12,fill:'#2B3236',transform:'rotate(14)'},mortar13);
const lamp13=glow(C13,330,700,300);
const L13=lime(C13);
function limeDrop(t){
  const a=T.s13_lime, d=K.tok, u=clamp((t-a)/(d-a));
  let x=lerp(330,640,eo(u)), y=834, rot=(x-330)*1.3;
  if(t>d){ const f=t-d; y=834+80+2600*f*f; x=640+40*f; rot+=200*f; if(t>d&&t<d+0.06)y=834+80*(t-d)/0.06; }
  L13.setAttribute('transform',`translate(${f2(x)} ${f2(Math.min(y,1330))}) rotate(${f2(rot)})`);
  lamp13.setAttribute('r',f2(290+16*Math.sin(t*9)));
}
// s14: the lime lies in the dark under the house
const L14=lime(sv('s14')); const g14=glow(sv('s14'),380,1330,110);
function limeUnder(t){ L14.setAttribute('transform',`translate(380 1330) rotate(${f2(-20+4*Math.sin(t*2))}) scale(.8)`); g14.setAttribute('opacity',f2(0.25+0.1*Math.sin(t*4))); }

// ---------- s15 THE ARM: reaches down through the floor, stretches long on "ยาว" ----------
const C15=sv('s15');
const back15=el('ellipse',{cx:470,cy:1000,rx:460,ry:560,fill:'url(#moonG)'},C15);   // cold moonlight behind the arm so the black shape reads
el('rect',{x:-100,y:500,width:1300,height:70,fill:'#05090C',stroke:'rgba(160,205,214,.25)','stroke-width':3},C15);
[160,880].forEach(x=>el('rect',{x,y:570,width:36,height:900,fill:'#04080A'},C15));
el('rect',{x:-100,y:1360,width:1300,height:120,fill:'rgba(4,8,10,.6)'},C15);
const L15=lime(C15); L15.setAttribute('transform','translate(380 1330) rotate(-20) scale(.85)');
const ARM=el('g',{},C15), armP=el('path',{fill:'#020405',stroke:'rgba(150,200,210,.3)','stroke-width':3},ARM), HAND=el('g',{},ARM);
const HP={fill:'#020405',stroke:'rgba(150,200,210,.3)','stroke-width':3};
el('path',{d:'M-30 -8 C-40 26 -36 58 -16 72 L16 72 C36 58 40 26 30 -8 Z',...HP},HAND);
[[-26,64,-38,128],[-10,70,-14,146],[6,70,8,150],[22,64,30,134]].forEach(([x1,y1,x2,y2])=>el('path',{d:`M${x1} ${y1} L${x2} ${y2}`,stroke:'#020405','stroke-width':15,'stroke-linecap':'round'},HAND));
el('path',{d:'M-30 20 L-58 70',stroke:'#020405','stroke-width':15,'stroke-linecap':'round'},HAND);
const ANG=17.3, LMAX=660;
function arm(t){
  const a=K.yuen, h=H.s15_arm;
  const L=t<a?0:(t<h?150*S(t-a,4,0.9):150+(LMAX-150)*S(t-h,7,0.85));
  const bend=24*Math.sin(t*3.1)*clamp(L/300);
  armP.setAttribute('d',`M-26 0 Q${f2(-26+bend)} ${f2(L/2)} -20 ${f2(L)} L20 ${f2(L)} Q${f2(26+bend)} ${f2(L/2)} 26 0 Z`); back15.setAttribute('opacity',f2(0.8+0.2*Math.sin(t*3)));
  HAND.setAttribute('transform',`translate(0 ${f2(L-6)}) rotate(${f2(4*Math.sin(t*5))})`);
  ARM.setAttribute('transform',`translate(620 560) rotate(${ANG})`);
  ARM.setAttribute('opacity',L>2?'1':'0');
}

// ---------- s16 eyes wide open in the dark (graphic, surprised, not scary) ----------
const C16=sv('s16'); const band=el('rect',{x:-100,y:560,width:1300,height:300,fill:'url(#warm)',opacity:.25},C16);
const EY=[380,700].map(cx=>{const g=el('g',{transform:`translate(${cx} 700)`},C16);
  const cp=el('clipPath',{id:'ec'+cx},g); const shape=el('path',{d:'M-120 0 Q0 -70 120 0 Q0 70 -120 0 Z'},cp);
  const white=el('path',{d:'M-120 0 Q0 -70 120 0 Q0 70 -120 0 Z',fill:'#C9D6D3',stroke:'#0B1418','stroke-width':6},g);
  const inner=el('g',{'clip-path':`url(#ec${cx})`},g); const iris=el('circle',{r:46,fill:'#2D5560'},inner); const pup=el('circle',{r:22,fill:'#05090B'},inner);
  const hl=el('circle',{cx:14,cy:-16,r:9,fill:'#fff'},inner);
  const brow=el('path',{d:'M-110 -80 Q0 -120 110 -80',fill:'none',stroke:'#0A1418','stroke-width':16,'stroke-linecap':'round'},g);
  return {g,shape,white,iris,pup,hl,brow};});
function eyes(t){
  const o=t>=K.hen?S(t-K.hen,12,0.6):0.15, w=t>=K.temta?S(t-K.temta,10,0.5):0;
  const hgt=lerp(10,70,clamp(o))+26*w, d=`M-120 0 Q0 ${f2(-hgt)} 120 0 Q0 ${f2(hgt)} -120 0 Z`;
  EY.forEach((e,i)=>{e.shape.setAttribute('d',d); e.white.setAttribute('d',d);
    const lx=6*Math.sin(t*1.7); e.iris.setAttribute('cx',f2(lx)); e.pup.setAttribute('cx',f2(lx)); e.pup.setAttribute('r',f2(22-9*w)); e.hl.setAttribute('cx',f2(lx+14));
    e.brow.setAttribute('transform',`translate(0 ${f2(-30*w-10*o)})`);});
  band.setAttribute('opacity',f2(0.2+0.06*Math.sin(t*7)));
}

// ---------- s17 temple at night (graphic: the daytime aerial footage showed a modern skyline) + the husband running to it ----------
const C17=sv('s17');
const moon17=el('circle',{cx:720,cy:470,r:70,fill:'#DCE8E6',opacity:.85},C17); el('circle',{cx:720,cy:470,r:190,fill:'rgba(200,230,235,.12)'},C17);
const TMP=el('g',{transform:'translate(640 1250)'},C17);
const TF={fill:'#03070A',stroke:'rgba(160,205,214,.35)','stroke-width':3,'stroke-linejoin':'round'};
el('path',{d:'M-330 0 L330 0 L310 -40 L-310 -40 Z',...TF},TMP);
el('path',{d:'M-250 -40 L250 -40 L250 -230 L-250 -230 Z',...TF},TMP);
[-190,-110,-30,50,130,210].forEach(x=>el('rect',{x:x-6,y:-200,width:22,height:150,fill:'#F2B25C',opacity:.55},TMP));
el('path',{d:'M-310 -220 L310 -220 L200 -330 L-200 -330 Z',...TF},TMP);
el('path',{d:'M-230 -320 L230 -320 L120 -450 L-120 -450 Z',...TF},TMP);
el('path',{d:'M-140 -440 L140 -440 L0 -600 Z',...TF},TMP);
el('path',{d:'M0 -600 C6 -640 22 -660 40 -650',fill:'none',stroke:'#03070A','stroke-width':12,'stroke-linecap':'round'},TMP);
[[-310,-220],[310,-220],[-230,-320],[230,-320]].forEach(([x,y])=>el('path',{d:`M${x} ${y} C${x+(x<0?-20:20)} ${y-30} ${x+(x<0?-10:10)} ${y-60} ${x+(x<0?-34:34)} ${y-66}`,fill:'none',stroke:'#03070A','stroke-width':10,'stroke-linecap':'round'},TMP));
el('rect',{x:-1000,y:1250,width:3000,height:700,fill:'#03070A'},C17);
const glow17=glow(C17,640,1120,260);
const run17=person(C17,{lower:'legs'});
function temple(t){
  const u=clamp((t-T.s17_temple)/1.6), x=lerp(150,470,eo(u)), sc=lerp(0.62,0.42,u);
  place(run17,x,lerp(1420,1330,u)+6*Math.abs(Math.sin(t*14)),sc,false);
  run17.g.setAttribute('transform',run17.g.getAttribute('transform')+' rotate(8)');
  run17.legs.forEach((l,i)=>l.setAttribute('transform',`translate(${i?16:-16} -215) rotate(${f2((i?1:-1)*34*Math.sin(t*14))})`));
  run17.arms.forEach((ag,i)=>ag.setAttribute('transform',`translate(${i?50:-50} -388) rotate(${f2((i?-1:1)*30*Math.sin(t*14))})`));
  glow17.setAttribute('r',f2(250+14*Math.sin(t*6))); moon17.setAttribute('opacity',f2(0.8+0.05*Math.sin(t*2)));
}

// ---------- s18 rampage: a lantern swinging in the gale ----------
const C18=sv('s18'), LAN=el('g',{},C18);
el('path',{d:'M0 -260 L0 0',stroke:'#0A0F12','stroke-width':6},LAN);
const lanG=glow(LAN,0,60,220); el('rect',{x:-34,y:10,width:68,height:96,rx:10,fill:'#F2B25C',stroke:'#1A0F06','stroke-width':8},LAN);
el('rect',{x:-44,y:0,width:88,height:16,rx:4,fill:'#1A0F06'},LAN); el('rect',{x:-44,y:100,width:88,height:16,rx:4,fill:'#1A0F06'},LAN);
function lantern(t){ const u=t-T.s18_rampage; LAN.setAttribute('transform',`translate(700 300) rotate(${f2(24*Math.sin(u*5.2)+8*Math.sin(u*11))})`);
  lanG.setAttribute('opacity',f2(0.6+0.4*Math.abs(Math.sin(u*13))));}

// ---------- twist ----------
// t1: "ฉบับเขียน / เก่าสุด ที่เจอ" in ink, word by word
function t1h(t){ const v=win(t,K.chabab,TD,FAST); if(!show($('t1h'),clamp(v*1.5)))return;
  $('t1h').style.transform=`translateY(${f2(24*(1-clamp(v))+4*Math.sin(t*2))}px) rotate(${f2(-1.5+0.6*Math.sin(t*1.3))}deg)`;
  [['t1b1',K.kaosud],['t1b2',K.jer]].forEach(([id,a])=>{const p=t>=a?S(t-a,POP[0],POP[1]):0; $(id).style.opacity=f2(clamp(p*1.5)); $(id).style.transform=`scale(${f2(Math.max(0.001,0.6+0.4*p))})`;});}

// desk camera: each twist shot is a new framing (a "cut" on the same paper) -> fast spring
const TS=['t2_doc','t2b_year','t3_khunsri','t4_chum','t4b_rumor','t5_stage','t5b_some','t6_boy','t7_dad','t8_lime','t8b_unknown'];
const CAM={t2_doc:[1.07,0,40],t2b_year:[1.0,0,-10],t3_khunsri:[1.06,0,40],t4_chum:[1.1,0,50],t4b_rumor:[1.0,0,-20],t5_stage:[1.04,-20,0],
  t5b_some:[1.05,0,30],t6_boy:[1.0,0,0],t7_dad:[1.04,0,10],t8_lime:[1.06,0,20],t8b_unknown:[1.0,0,0]};
const camS=track(1.07,TS.map(id=>[T[id],CAM[id][0],FAST])), camX=track(0,TS.map(id=>[T[id],CAM[id][1],FAST])), camY=track(40,TS.map(id=>[T[id],CAM[id][2],FAST]));
function desk(t){
  if(t<TD-0.1||t>=TC+XF)return;
  $('desk').style.transform=`translate(${f2(camX(t)+6*Math.sin(t*0.8))}px,${f2(camY(t)+5*Math.cos(t*0.7))}px) rotate(${f2(0.4*Math.sin(t*0.5))}deg) scale(${camS(t).toFixed(4)})`;
  $('paperImg').style.transform=`translate(${f2(10*Math.sin(t*0.3))}px,${f2(8*Math.cos(t*0.25))}px)`;
}
// the document card: one element, content morphs A (สยามประเภท 2442) -> B (นาก = ลูกสาวขุนศรี) -> C (ผัว ชุ่ม / มาก fades)
const docV=t=>win(t,TD,T.t5b_some,BOUNCE);
const docS=track(1,[[T.t2b_year,0.9],[T.t3_khunsri,1],[T.t4b_rumor,0.72],[T.t5_stage,0.55]]), docY=track(0,[[T.t2b_year,-60],[T.t3_khunsri,0],[T.t4b_rumor,-80],[T.t5_stage,-110]]);
const docXs=track(0,[[T.t5_stage,-175]]);
function docF(t){
  const v=docV(t), d=$('doc'); if(!show(d,clamp(v*1.6)))return;
  d.style.transform=`translate(${f2(docXs(t))}px,${f2(docY(t)+40*(1-clamp(v))+5*Math.sin(t*1.6))}px) rotate(${f2(-1.2+0.6*Math.sin(t*1.1)-2*(1-clamp(v)))}deg) scale(${f2(Math.max(0.001,docS(t)*(0.8+0.2*v)))})`;
  const sw=(a,b)=>{const i=t>=a?clamp((t-a)/0.12):0, o=b!=null&&t>=b?clamp((t-b)/0.1):0; return i*(1-o);};
  const A=(t<T.t3_khunsri?1:1-clamp((t-T.t3_khunsri)/0.1)), B=sw(K.luksao-0.08,T.t4_chum), C=sw(T.t4_chum,null);
  [['docA',A],['docB',B],['docC',C]].forEach(([id,o])=>{show($(id),o); $(id).style.transform=`translateY(${f2(16*(1-o))}px)`;});
  // ✅ stamp: thumps on at "หนังสือพิมพ์", stays while the card shows facts
  const st=t>=K.nangsue+0.1?S(t-K.nangsue-0.1,20,0.5):0, sto=t>=T.t4b_rumor?1-clamp((t-T.t4b_rumor)/0.15):1;
  $('stamp').style.opacity=f2(clamp(st*2)*sto); $('stamp').style.transform=`rotate(-4deg) scale(${f2(Math.max(0.001,1.6-0.6*st))})`;
  // ชุ่ม grows on "นายชุ่ม"
  const ch=t>=K.chum?S(t-K.chum,16,0.55):0; $('chum').style.transform=`scale(${f2(Math.max(0.001,0.3+0.7*ch))})`; $('chum').style.opacity=f2(clamp(ch*2));
}
// "มาก": sits beside ชุ่ม (big, grey), fades + shrinks on "ไม่ใช่มาก" (no strike-through), then floats to the later part of the timeline
const mX=track(760,[[T.t4b_rumor,620,MORPH]]), mY=track(500,[[H.t4_chum,560,SOFT],[T.t4b_rumor,905,MORPH]]);
const mS=track(1.0,[[H.t4_chum,0.7,MORPH],[T.t4b_rumor,0.62,MORPH]]), mO=track(0.75,[[H.t4_chum,0.32,SOFT],[K.wakan,0.95,MORPH]]);
function makF(t){
  const e=$('makC'), a=T.t4_chum+0.2, v=win(t,a,T.t5b_some,POP); if(!show(e,clamp(v*1.4)*clamp(mO(t))))return;
  const col=t>=K.wakan?mix('#7A6A58','#8A4B12',clamp((t-K.wakan)/0.3)):'#7A6A58'; e.style.color=col;
  e.style.transform=`translate(${f2(mX(t)-80)}px,${f2(mY(t)-50+4*Math.sin(t*2.5))}px) rotate(${f2(-3+2*Math.sin(t*1.7))}deg) scale(${f2(Math.max(0.001,mS(t)*v))})`;
}
// timeline: 2442 (left) -> ปัจจุบัน (right); later point "ทีหลัง" (no year) where มาก lands
const TLg=el('g',{opacity:0},sv('tl')), TY=980;
const tLine=el('path',{d:`M150 ${TY} L840 ${TY}`,stroke:INKC,'stroke-width':10,'stroke-linecap':'round',fill:'none'},TLg);
const tHead=el('path',{d:`M816 ${TY-24} L848 ${TY} L816 ${TY+24}`,stroke:INKC,'stroke-width':10,'stroke-linecap':'round','stroke-linejoin':'round',fill:'none'},TLg);
const tDot=el('circle',{cx:200,cy:TY,r:22,fill:'#8A3B12',stroke:INKC,'stroke-width':6},TLg);
const tYr=el('text',{x:200,y:TY+76,'text-anchor':'middle','font-family':'Kanit','font-weight':900,'font-size':58,fill:INKC},TLg); tYr.textContent='2442';
const tNow=el('text',{x:790,y:TY+72,'text-anchor':'middle','font-family':'Kanit','font-weight':700,'font-size':44,fill:INKL},TLg); tNow.textContent='ปัจจุบัน';
const tBr=el('path',{d:`M220 ${TY-46} Q510 ${TY-110} 800 ${TY-46}`,stroke:INKL,'stroke-width':6,fill:'none','stroke-dasharray':'14 12'},TLg);
const tBrT=el('text',{x:510,y:TY-104,'text-anchor':'middle','font-family':'Kanit','font-weight':700,'font-size':46,fill:INKL},TLg); tBrT.textContent='ร้อยกว่าปี';
const tLate=el('circle',{cx:620,cy:TY,r:18,fill:'#F3E3BF',stroke:'#8A4B12','stroke-width':6,'stroke-dasharray':'8 6'},TLg);
const tLateT=el('text',{x:620,y:TY+72,'text-anchor':'middle','font-family':'Kanit','font-weight':700,'font-size':44,fill:'#8A4B12'},TLg); tLateT.textContent='ทีหลัง';
function timeline(t){
  const v=win(t,T.t2b_year,T.t5b_some,FAST); TLg.setAttribute('opacity',f2(clamp(v*1.5))); if(v<0.003)return;
  const g=clamp(S(t-T.t2b_year,6,1)); tLine.setAttribute('d',`M150 ${TY} L${f2(150+690*g)} ${TY}`); tHead.setAttribute('opacity',f2(clamp((g-0.9)*10)));
  tNow.setAttribute('opacity',f2(clamp((g-0.85)*7)));
  const dp=S(t-T.t2b_year,POP[0],POP[1]); tDot.setAttribute('r',f2(Math.max(0.1,22*dp+3*Math.sin(t*6)))); tYr.setAttribute('opacity',f2(clamp(dp*2)));
  const br=t>=K.roi?clamp(S(t-K.roi,8,0.9)):0; tBr.setAttribute('stroke-dashoffset',f2(-t*30)); tBr.setAttribute('opacity',f2(br)); tBrT.setAttribute('opacity',f2(br*(t>=T.t3_khunsri?0.0+1-clamp((t-T.t3_khunsri)/0.2):1)));
  tBr.setAttribute('opacity',f2(br*(t>=T.t3_khunsri?1-clamp((t-T.t3_khunsri)/0.2):1)));
  const lt=t>=T.t4b_rumor+0.25?S(t-T.t4b_rumor-0.25,POP[0],POP[1]):0; tLate.setAttribute('r',f2(Math.max(0.1,18*lt))); tLateT.setAttribute('opacity',f2(clamp(K.thilang<=t?S(t-K.thilang,POP[0],POP[1]):0)));
}
// tags ว่ากันว่า / บางตำรา (⚠️ claims): the บางตำรา tag stays on screen through t6 and t7
function tags(t){
  const w=$('tagW'), vw=win(t,K.wakan,T.t5b_some,BOUNCE);
  if(show(w,clamp(vw*2))) w.style.transform=`translate(${f2(120)}px,${f2(770+4*Math.sin(t*2))}px) rotate(${f2(-3+Math.sin(t*1.6))}deg) scale(${f2(Math.max(0.001,vw))})`;
  const b=$('tagB'), vb=win(t,K.bang,T.t8_lime,BOUNCE), small=t>=T.t6_boy?S(t-T.t6_boy,FAST[0],FAST[1]):0;
  if(show(b,clamp(vb*2))) b.style.transform=`translate(${f2(lerp(300,120,small))}px,${f2(lerp(330,262,small)+4*Math.sin(t*2))}px) rotate(${f2(-3+Math.sin(t*1.6))}deg) scale(${f2(Math.max(0.001,vb*lerp(1.5,1,small)))})`;
}
// t5 stage card (the curtain footage as a photo card, not full frame) pinned above "ทีหลัง"
function stageF(t){
  const c=$('stageCard'), l=$('stageLab'), v=win(t,T.t5_stage,T.t5b_some,BOUNCE);
  if(show(c,clamp(v*1.6))) c.style.transform=`translate(${f2(540)}px,${f2(300+30*(1-clamp(v)))}px) rotate(${f2(3-1.2*Math.sin(t*1.4))}deg) scale(${f2(Math.max(0.001,0.7+0.3*v))})`;
  const lv=t>=K.lakhon?win(t,K.lakhon,T.t5b_some,POP):0; if(show(l,clamp(lv*2))) l.style.transform=`translate(${f2(640)}px,${f2(760)}px) scale(${f2(Math.max(0.001,lv))})`;
}
// t5b-t8b ink drawings (sketchy, dashed, semi-transparent: "บางตำรา", not fact)
const DK=sv('desk2');
const BOOK=el('g',{opacity:0},DK);
el('path',{d:'M-300 40 Q-150 -10 0 40 L0 300 Q-150 250 -300 300 Z',fill:'#F6E9C8',stroke:INKC,'stroke-width':8},BOOK);
el('path',{d:'M300 40 Q150 -10 0 40 L0 300 Q150 250 300 300 Z',fill:'#F6E9C8',stroke:INKC,'stroke-width':8},BOOK);
[90,130,170,210].forEach(y=>{el('path',{d:`M-260 ${y} Q-150 ${y-30} -40 ${y}`,stroke:'rgba(59,36,20,.35)','stroke-width':6,fill:'none'},BOOK); el('path',{d:`M40 ${y} Q150 ${y-30} 260 ${y}`,stroke:'rgba(59,36,20,.35)','stroke-width':6,fill:'none'},BOOK);});
const BOOKP=el('path',{d:'M0 40 Q120 -40 260 20 L260 280 Q120 230 0 300 Z',fill:'#FBF2DC',stroke:INKC,'stroke-width':6,opacity:0},BOOK);
const inkO={fill:'rgba(59,36,20,.55)',stroke:INKC,sw:4,dash:'14 9'};
const boy=person(DK,{...inkO,lower:'legs'}), dad=person(DK,{...inkO,lower:'legs'}), nw=person(DK,{...inkO,hair:'long'});
const QM=el('text',{'font-family':'Kanit','font-weight':900,'font-size':200,fill:'#8A3B12',stroke:INKC,'stroke-width':6,'text-anchor':'middle',opacity:0},DK); QM.textContent='?';
const L8=lime(DK);
const MAG=el('g',{opacity:0},DK); el('circle',{r:120,fill:'rgba(255,250,235,.35)',stroke:INKC,'stroke-width':16},MAG);
el('path',{d:'M84 84 L190 190',stroke:INKC,'stroke-width':30,'stroke-linecap':'round'},MAG);
const MQ=el('text',{x:0,y:44,'font-family':'Kanit','font-weight':900,'font-size':130,fill:'#8A3B12','text-anchor':'middle'},MAG); MQ.textContent='?';
function inkF(t){
  const vb=win(t,T.t5b_some,T.t6_boy,BOUNCE); BOOK.setAttribute('opacity',f2(clamp(vb*1.5)));
  BOOK.setAttribute('transform',`translate(540 ${f2(560+30*(1-clamp(vb)))}) scale(${f2(Math.max(0.001,0.8+0.2*vb))})`);
  const pf=t>=K.phithang?clamp((t-K.phithang)/0.5):0; BOOKP.setAttribute('opacity',f2(pf>0&&pf<1?1:0)); BOOKP.setAttribute('transform',`scale(${f2(1-2*pf)} 1)`);
  // boy (from "อุบาย") + ? ; dad + new wife join on "เมียใหม่"; boy steps aside
  const vy=win(t,T.t6_boy,T.t8_lime,BOUNCE), side=t>=T.t7_dad?S(t-T.t7_dad,MORPH[0],MORPH[1]):0;
  boy.g.setAttribute('opacity',f2(clamp(vy*1.5))); place(boy,lerp(540,300,side),1000+20*(1-clamp(vy)),0.82,false);
  boy.arms.forEach((ag,i)=>ag.setAttribute('transform',`translate(${i?50:-50} -388) rotate(${f2((i?-1:1)*(8+10*side))})`));
  QM.setAttribute('opacity',f2(clamp(vy*1.5))); QM.setAttribute('x',f2(lerp(720,300,side))); QM.setAttribute('y',f2(lerp(700,520,side)+10*Math.sin(t*3)));
  QM.setAttribute('transform',`rotate(${f2(8*Math.sin(t*2.6))} ${f2(lerp(720,300,side))} 640)`);
  const vd=win(t,T.t7_dad,T.t8_lime,BOUNCE), sp=t>=K.miamai?S(t-K.miamai,BOUNCE[0],BOUNCE[1]):0;
  dad.g.setAttribute('opacity',f2(clamp(vd*1.5))); place(dad,600,1000+30*(1-clamp(vd)),1.05,false);
  nw.g.setAttribute('opacity',f2(clamp(sp*1.5)*clamp(win(t,K.miamai,T.t8_lime,POP)*1.5))); place(nw,770,1000+30*(1-clamp(sp)),0.98,true); hairSway(nw,t);
  // t8: the lime rolls back in + "มาจากฉบับไหน?"
  const vl=win(t,T.t8_lime,TC,FAST), rl=t>=T.t8_lime?eo((t-T.t8_lime)/0.7):0;
  L8.setAttribute('opacity',f2(clamp(vl*2))); L8.setAttribute('transform',`translate(${f2(lerp(980,540,rl))} ${f2(700+14*Math.abs(Math.sin(rl*9))*(1-rl))}) rotate(${f2(-440*rl)}) scale(1.5)`);
  const q=$('q8'), vq=t>=K.manao2?win(t,K.manao2,TC,POP):0; if(show(q,clamp(vq*2))) q.style.transform=`translateY(${f2(20*(1-clamp(vq)))}px) scale(${f2(Math.max(0.001,0.7+0.3*vq))}) rotate(${f2(-1.5+Math.sin(t*2))}deg)`;
  // t8b: magnifier sweeps the page
  const vm=win(t,T.t8b_unknown,TC,BOUNCE), u=t-T.t8b_unknown; MAG.setAttribute('opacity',f2(clamp(vm*2)));
  MAG.setAttribute('transform',`translate(${f2(540+260*Math.sin(u*1.9))} ${f2(820+70*Math.sin(u*3.1))}) rotate(${f2(-10+6*Math.sin(u*2))}) scale(${f2(Math.max(0.001,vm))})`);
}

// ---------- punches / shakes ----------
const PUNCH=[[H.s7_out,0.05],[H.s15_arm,0.07],[K.chum,0.05],[H.t4_chum,0.04]];
function fx(t){
  let p=0; PUNCH.forEach(([a,amp])=>{const u=t-a; if(u>=0&&u<0.8)p+=amp*Math.exp(-u*7)*Math.cos(u*13);});
  const sh=(t>=H.s15_arm&&t<H.s15_arm+0.35)?8*Math.sin(t*80)*(1-(t-H.s15_arm)/0.35):0;
  const pd=(t>=T.s12_mortar&&t<T.s13_lime)?3*Math.max(0,Math.sin(t*16)):0;   // pestle pounding
  $('stage').style.transform=`translate(${f2(sh)}px,${f2(pd)}px) scale(${(1+p).toFixed(4)})`;
}

// ---------- captions: spring in on the word; last chunk clears before the loop seam ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,30,0.6);
  const fadeO=i===CAPT.length-1?1-clamp((t-(DUR-0.17))/0.1):1;
  capEls[i].style.opacity=f2(fadeO);
  capEls[i].style.transform=`translateY(${f2(22*(1-a))}px) scale(${(0.78+0.22*a).toFixed(4)}) rotate(${f2(0.6*Math.sin(t*3))}deg)`;
}

function render(t){ scenes(t); atmos(t); fx(t); title(t); kin(t); people(t); limeDrop(t); limeUnder(t); arm(t); eyes(t); temple(t); lantern(t);
  t1h(t); desk(t); docF(t); makF(t); timeline(t); tags(t); stageF(t); inkF(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
if(document.fonts&&document.fonts.ready)document.fonts.ready.then(()=>render(proxy._t));
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
