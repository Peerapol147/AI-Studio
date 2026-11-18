<!doctype html>
<!-- GENERATED: edit index.html.tpl, then run `python3 build_index.py` -->
<html lang="th"><head><meta charset="UTF-8"/><meta name="viewport" content="width=1080, height=1920"/>
<link rel="stylesheet" href="fonts/fonts.css"/>
<script src="https://cdn.jsdelivr.net/npm/gsap@3.15.0/dist/gsap.min.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box}
html,body{width:1080px;height:1920px;overflow:hidden;background:#000}
#root{position:relative;width:1080px;height:1920px;overflow:hidden;font-family:'Kanit',sans-serif;background:#0B1630}
.sc{position:absolute;left:0;top:0;width:1080px;height:1920px;overflow:hidden;opacity:0}
.kb{position:absolute;left:0;top:0;width:1080px;height:1920px;transform-origin:50% 50%}
.kb video{position:absolute;left:0;top:0;width:1080px;height:1920px;object-fit:cover}
#gbg{position:absolute;left:-60px;top:-60px;width:1200px;height:2040px;background:radial-gradient(ellipse at 50% 34%,#22336A 0%,#16244D 45%,#0B1630 100%)}
.full{position:absolute;left:0;top:0;width:1080px;height:1920px}
.vig{position:absolute;left:0;top:0;width:1080px;height:1920px;background:radial-gradient(ellipse at 50% 42%,rgba(6,10,24,0) 52%,rgba(6,10,24,.55) 100%)}
#scrglow{position:absolute;left:552px;top:822px;width:600px;height:600px;border-radius:50%;mix-blend-mode:screen;
  background:radial-gradient(circle,rgba(205,222,255,.55) 0%,rgba(150,180,255,.18) 40%,rgba(150,180,255,0) 70%)}
#asktint{position:absolute;left:0;top:0;width:1080px;height:1920px;background:linear-gradient(rgba(11,22,48,.72),rgba(11,22,48,.5) 55%,rgba(11,22,48,.7))}
#tshade{position:absolute;left:0;top:0;width:1080px;height:820px;background:linear-gradient(rgba(8,14,32,.72),rgba(8,14,32,0))}
#title{position:absolute;left:0;top:0;width:1080px;height:760px}
#title .tl{position:absolute;left:0;width:1080px;text-align:center;font-weight:900;line-height:1;white-space:nowrap;
  -webkit-text-stroke:24px #0A1022;paint-order:stroke fill;transform-origin:50% 60%}
#pill{position:absolute;left:0;top:0;height:92px;padding:0 34px 0 96px;border-radius:46px;background:rgba(11,22,48,.82);border:5px solid #FFB366;
  color:#F3EBDD;font-weight:700;font-size:54px;line-height:84px;white-space:nowrap}
#pill svg{position:absolute;left:22px;top:13px}
#caps{position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:60;pointer-events:none}
.cap{position:absolute;left:40px;width:1000px;top:1152px;height:0;text-align:center}
.cap span{position:absolute;left:0;width:1000px;bottom:-50px;display:block;color:#F3EBDD;font-weight:700;line-height:1.2;white-space:nowrap;
  -webkit-text-stroke:16px #0A1022;paint-order:stroke fill;transform-origin:50% 80%;text-shadow:0 8px 22px rgba(10,16,34,.85)}
.cap em{font-style:normal;color:#FFB366}
</style></head><body>
<div id="root" data-composition-id="main" data-start="0" data-duration="%%DUR%%" data-width="1080" data-height="1920"
 data-motion-blur="on" data-motion-blur-events="on">

<div id="scenes" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:0;isolation:isolate">
  <div class="sc" id="sc-hook"><div class="kb" id="kb-hook">%%VID:hook%%</div><div id="scrglow"></div></div>
  <div class="sc" id="sc-scroll"><div class="kb" id="kb-scroll">%%VID:scroll%%</div></div>
  <div class="sc" id="sc-tired"><div class="kb" id="kb-tired">%%VID:tired%%</div></div>
  <div class="sc" id="sc-room"><div class="kb" id="kb-room">%%VID:room%%</div></div>
  <div class="sc" id="sc-sleep"><div class="kb" id="kb-sleep">%%VID:sleep%%</div></div>
  <div class="sc" id="sc-morning"><div class="kb" id="kb-morning">%%VID:morning%%</div></div>
  <div class="sc" id="sc-write"><div class="kb" id="kb-write">%%VID:write%%</div></div>
  <div class="sc" id="sc-ask"><div class="kb" id="kb-ask">%%VID:ask%%</div><div id="asktint"></div></div>
  <div class="sc" id="sc-gfx"><div id="gbg"></div><svg class="full" id="stars" viewBox="0 0 1080 1920"></svg><div class="vig"></div></div>
</div>

<!-- one shape (the thought bubble) + every diagram, in one SVG with one camera -->
<svg id="ov" class="full" viewBox="0 0 1080 1920" width="1080" height="1920" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;z-index:10;overflow:visible">
  <defs>
    <radialGradient id="ambg"><stop offset="0" stop-color="#FFE2B8"/><stop offset=".35" stop-color="#FFB366" stop-opacity=".85"/><stop offset="1" stop-color="#FFB366" stop-opacity="0"/></radialGradient>
    <radialGradient id="coolg"><stop offset="0" stop-color="#F3EBDD" stop-opacity=".85"/><stop offset=".45" stop-color="#BCCBF2" stop-opacity=".45"/><stop offset="1" stop-color="#BCCBF2" stop-opacity="0"/></radialGradient>
    <radialGradient id="lampg"><stop offset="0" stop-color="#FFD9A0" stop-opacity=".9"/><stop offset=".4" stop-color="#FFB366" stop-opacity=".35"/><stop offset="1" stop-color="#FFB366" stop-opacity="0"/></radialGradient>
    <radialGradient id="scrg"><stop offset="0" stop-color="#DCE7FF" stop-opacity=".8"/><stop offset=".5" stop-color="#9DB4F0" stop-opacity=".25"/><stop offset="1" stop-color="#9DB4F0" stop-opacity="0"/></radialGradient>
    <linearGradient id="tableg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1E2A52"/><stop offset="1" stop-color="#0B1630" stop-opacity="0"/></linearGradient>
    <clipPath id="brainclip"><path id="clipP" d=""/></clipPath>
  </defs>
  <g id="cam">
    <g id="head" opacity="0">
      <path id="headP" d="M470 1130 L470 1046 C410 1024 356 962 348 880 C332 760 404 640 544 630 C664 622 744 702 752 792 C756 832 772 852 792 882 C802 897 792 907 772 908 C772 932 766 950 760 962 C770 977 760 992 744 994 C738 1022 718 1036 680 1036 L642 1037 L642 1130 Z"
        fill="#1F2D5C" stroke="#4A5E9A" stroke-width="6" stroke-linejoin="round"/>
      <circle id="headGlow" cx="560" cy="780" r="150" fill="url(#ambg)" opacity=".35"/>
      <ellipse id="orbit" cx="550" cy="560" rx="340" ry="140" fill="none" stroke="#FFB366" stroke-width="7" stroke-linecap="round" stroke-dasharray="26 22" opacity="0"/>
    </g>
    <g id="phoneG" opacity="0">
      <ellipse id="lampGlow" cx="800" cy="740" rx="480" ry="460" fill="url(#lampg)"/>
      <path d="M90 905 L990 905 L1050 1010 L30 1010 Z" fill="#22305E"/>
      <rect x="30" y="1010" width="1020" height="360" fill="url(#tableg)"/>
      <rect x="786" y="770" width="28" height="135" rx="10" fill="#3A2A20"/>
      <ellipse cx="800" cy="905" rx="80" ry="16" fill="#2A1E18"/>
      <path id="shade" d="M712 610 L888 610 L948 780 L652 780 Z" fill="#FFB366" stroke="#FFD9A0" stroke-width="4" stroke-linejoin="round"/>
      <ellipse id="scrGlow" cx="430" cy="760" rx="300" ry="250" fill="url(#scrg)"/>
      <g id="phone">
        <rect x="-175" y="-52" width="350" height="104" rx="26" fill="#0E1530" stroke="#4A5E9A" stroke-width="5"/>
        <rect id="phScr" x="-160" y="-38" width="320" height="76" rx="16" fill="#CFE0FF"/>
        <g id="phBack" opacity="0"><circle cx="-118" cy="0" r="11" fill="#2A3768" stroke="#4A5E9A" stroke-width="3"/></g>
      </g>
    </g>
    <g id="brainIn" opacity="0">
      <g clip-path="url(#brainclip)">
        <circle id="front" cx="300" cy="560" r="230" fill="url(#coolg)" opacity="0"/>
        <g id="sulci" fill="none" stroke="#F3EBDD" stroke-width="7" stroke-linecap="round" opacity=".32">
          <path d="M300 520 C360 470 430 500 470 455"/><path d="M620 440 C680 480 740 450 810 500"/><path d="M320 700 C400 660 470 720 540 680"/>
          <path d="M600 600 C660 560 720 620 800 600"/><path d="M420 830 C480 795 560 845 620 805"/><path d="M240 640 C285 610 300 570 282 530"/>
          <path d="M700 770 C750 735 805 775 840 725"/><path d="M470 560 C520 520 560 580 610 540"/>
        </g>
      </g>
      <g id="cereb" fill="none" stroke="#F3EBDD" stroke-linecap="round">
        <path d="M630 880 C636 930 646 960 660 985" stroke-width="44" stroke-opacity=".16"/>
        <ellipse cx="770" cy="872" rx="112" ry="60" fill="#F3EBDD" fill-opacity=".1" stroke-width="5" stroke-opacity=".7"/>
        <path d="M690 862 C730 846 800 846 852 866 M694 888 C740 900 800 900 848 884" stroke-width="4" stroke-opacity=".45"/></g>
      <g id="emo"><circle id="emoGlow" cx="610" cy="760" r="110" fill="url(#ambg)"/>
        <circle id="ring1" cx="610" cy="760" r="60" fill="none" stroke="#FFB366" stroke-width="7" opacity="0"/>
        <circle id="ring2" cx="610" cy="760" r="60" fill="none" stroke="#FFB366" stroke-width="5" opacity="0"/>
        <circle id="emoCore" cx="610" cy="760" r="30" fill="#FFD9A0"/></g>
      <text id="labEmo" x="470" y="868" text-anchor="middle" font-family="Kanit" font-weight="700" font-size="48" fill="#FFB366" stroke="#0A1022" stroke-width="12" paint-order="stroke" opacity="0">ส่วนอารมณ์</text>
      <g id="brakeG" opacity="0">
        <text x="330" y="470" text-anchor="middle" font-family="Kanit" font-weight="700" font-size="48" fill="#F3EBDD" stroke="#0A1022" stroke-width="12" paint-order="stroke">ส่วนเบรก</text>
        <rect x="220" y="494" width="220" height="26" rx="13" fill="#0A1022" stroke="#F3EBDD" stroke-width="4" stroke-opacity=".6"/>
        <rect id="gauge" x="226" y="500" width="208" height="14" rx="7" fill="#F3EBDD"/>
      </g>
    </g>
    <g id="shapeG">
      <circle id="tr1" r="10" fill="#F3EBDD" fill-opacity=".16" stroke="#F3EBDD" stroke-width="5" opacity="0"/>
      <circle id="tr2" r="6" fill="#F3EBDD" fill-opacity=".16" stroke="#F3EBDD" stroke-width="4" opacity="0"/>
      <path id="shGlow" d="" fill="none" stroke="#FFB366" stroke-width="28" stroke-linejoin="round" opacity=".16"/>
      <path id="shP" d="" stroke-width="6" stroke-linejoin="round"/>
      <g id="knotG"><path id="knot" d="" fill="none" stroke="#FFB366" stroke-linecap="round" stroke-linejoin="round" vector-effect="non-scaling-stroke"/></g>
      <g id="cardT" opacity="0">
        <text x="0" y="-38" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="78" fill="#0B1630">คุยกับผู้เชี่ยวชาญ</text>
      </g>
      <g id="hot" opacity="0"><rect id="hotR" x="-330" y="-49" width="660" height="98" rx="49" fill="#0B1630" stroke="#FFB366" stroke-width="0"/>
        <text id="hotT" x="0" y="18" text-anchor="middle" font-family="Kanit" font-weight="700" font-size="50" fill="#F3EBDD">สายด่วนสุขภาพจิต <tspan id="hotN" fill="#FFB366" font-weight="900" font-size="60">1323</tspan></text>
      </g>
      <g id="askT" opacity="0">
        <text x="0" y="28" text-anchor="middle" font-family="Kanit" font-weight="900" font-size="84" fill="#0B1630">ตอนนี้<tspan fill="#C4621A">กี่โมง</tspan>แล้ว?</text>
      </g>
    </g>
  </g>
  <g id="clk" opacity="0">
    <circle r="100" fill="#14214A" stroke="#F3EBDD" stroke-width="9"/>
    <g id="ticks" stroke="#F3EBDD" stroke-width="7" stroke-linecap="round" opacity=".8"></g>
    <path id="hHour" d="M0 10 L0 -48" stroke="#F3EBDD" stroke-width="13" stroke-linecap="round"/>
    <path id="hMin" d="M0 12 L0 -74" stroke="#F3EBDD" stroke-width="9" stroke-linecap="round"/>
    <path id="hSec" d="M0 16 L0 -80" stroke="#FFB366" stroke-width="5" stroke-linecap="round"/>
    <circle r="11" fill="#FFB366"/>
    <text id="clkT" y="168" text-anchor="middle" font-family="Kanit" font-weight="700" font-size="54" fill="#F3EBDD" stroke="#0A1022" stroke-width="12" paint-order="stroke">03:00</text>
  </g>
</svg>
<svg id="dust" class="full" viewBox="0 0 1080 1920" style="position:absolute;left:0;top:0;z-index:12;mix-blend-mode:screen;pointer-events:none"></svg>

<div id="over" data-layout-allow-overflow data-layout-allow-overlap style="position:absolute;left:0;top:0;width:1080px;height:1920px;z-index:14">
  <div id="tshade"></div>
  <div id="title">
    <div id="pill"><svg width="60" height="60" viewBox="-30 -30 60 60"><circle r="25" fill="none" stroke="#FFB366" stroke-width="6"/>
      <path d="M0 -15 L0 0 L13 0" fill="none" stroke="#F3EBDD" stroke-width="6" stroke-linecap="round" stroke-linejoin="round"/></svg>03:00</div>
    <div class="tl" id="tl1" style="top:310px;font-size:150px;color:#F3EBDD">ทำไมยิ่งดึก</div>
    <div class="tl" id="tl2" style="top:500px;font-size:160px;color:#FFB366">ยิ่งคิดมาก?</div>
  </div>
</div>

<div id="caps" data-track-kind="captions">
%%CAPS%%
</div>

<audio id="vo" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="30" data-volume="1" src="assets/vo-th.mp3"></audio>
<audio id="music" class="clip" data-start="0" data-duration="%%DUR%%" data-track-index="31" data-volume="0.12" src="assets/music-bed.mp3"></audio>
</div>

<script>
/* Motion: closed-form springs (motion-broll engine). One thought-bubble shape morphs through the whole clip
   (small -> big -> brain -> orbit -> big -> small at dawn -> heavy -> help card -> comment bubble).
   Shot times = assets/audio/shots-th.json, word anchors = words.json (both injected by build_index.py). */
(function(){
const D=%%DATA%%, DUR=D.dur, CAPT=D.capt, K=D.k, SH=D.sh;
const T={},H={},W={}; for(const k in SH){T[k]=SH[k].start; W[k]=SH[k].word; if(SH[k].hit!=null)H[k]=SH[k].hit;}
const NS='http://www.w3.org/2000/svg';
// ---------- spring kit ----------
const clamp=(x,a=0,b=1)=>Math.min(b,Math.max(a,x)), lerp=(a,b,u)=>a+(b-a)*u;
const eo=x=>{x=clamp(x);return 1-Math.pow(1-x,3)}, eio=x=>{x=clamp(x);return x*x*x*(x*(6*x-15)+10)}, ei=x=>{x=clamp(x);return x*x*x};
const S=(tau,w,z)=>{if(tau<=0)return 0;
  if(z<1){const wd=w*Math.sqrt(1-z*z);return 1-Math.exp(-z*w*tau)*(Math.cos(wd*tau)+z*w/wd*Math.sin(wd*tau));}
  return 1-Math.exp(-w*tau)*(1+w*tau);};
const MORPH=[13,0.82],FAST=[22,0.85],SLOW=[7,0.95],SOFTB=[13,0.6],CAM=[6.5,1],CAMF=[12,1],HEAVY=[8,0.55];
const track=(v0,keys,def=MORPH)=>{let p=v0;const ks=[];for(const k of keys){const d=k[1]-p;p=k[1];const sp=k[2]||def;if(d!==0)ks.push([k[0],d,sp[0],sp[1]]);}
  return t=>{let v=v0;for(const k of ks)v+=k[1]*S(t-k[0],k[2],k[3]);return v;};};
const hex=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const mixc=(a,b,u)=>{const x=hex(a),y=hex(b);u=clamp(u);return '#'+x.map((v,i)=>Math.round(lerp(v,y[i],u)).toString(16).padStart(2,'0')).join('');};
const vis=(t,tin,tout,o={})=>{const lin=o.lin??0.2,lout=o.lout??0.14;
  const a=tin==null?1:eo((t-tin)/lin), b=tout==null?0:eo((t-tout)/lout); return {o:a*(1-b),a,b};};
const $=id=>document.getElementById(id);
const el=(tag,attrs,parent)=>{const e=document.createElementNS(NS,tag);for(const k in attrs)e.setAttribute(k,attrs[k]);parent.appendChild(e);return e;};
const f2=v=>v.toFixed(2), op=(e,v)=>e.setAttribute('opacity',clamp(v).toFixed(3));
// deterministic pseudo-random
const rnd=(i)=>{const x=Math.sin(i*127.1+311.7)*43758.5453;return x-Math.floor(x);};

// ---------- scenes ----------
const SHOT=(id,kb,k0,k1,r0,r1,ty,org)=>({id,kb,k0,k1,r0,r1,ty:ty||0,org:org||'50% 50%'});
const SC=[
 {...SHOT('sc-hook','kb-hook',1.0,1.1,0,-0.8,0,'56% 44%'),a:0,in:'none'},
 {...SHOT('sc-scroll','kb-scroll',1.12,1.2,0.6,-0.6,-110,'48% 40%'),a:T.scroll,in:'zoom'},
 {id:'sc-gfx',a:T.small,in:'zoom'},
 {...SHOT('sc-tired','kb-tired',1.05,1.13,-0.8,0.6,0,'50% 36%'),a:T.tired,in:'zoom'},
 {id:'sc-gfx',a:T.brain,in:'match'},
 {...SHOT('sc-room','kb-room',1.04,1.13,0.8,-0.5,0,'58% 50%'),a:T.room,in:'zoom'},
 {id:'sc-gfx',a:T.loop,in:'match'},
 {...SHOT('sc-sleep','kb-sleep',1.14,1.2,-0.6,0.5,-110,'40% 50%'),a:T.sleep,in:'match'},
 {...SHOT('sc-morning','kb-morning',1.05,1.12,0.5,-0.5,0,'45% 45%'),a:T.morning,in:'dawn'},
 {...SHOT('sc-write','kb-write',1.3,1.38,-0.6,0.6,-250,'45% 60%'),a:T.write,in:'zoom'},
 {id:'sc-gfx',a:T.phone_down,in:'match'},
 {...SHOT('sc-ask','kb-ask',1.04,1.1,0,0.8,0,'56% 44%'),a:T.ask,in:'match'},
];
SC.forEach((s,i)=>{s.next=SC[i+1]; s.b=s.next?s.next.a:DUR; if(s.kb)$(s.kb).style.transformOrigin=s.org;});
const XF=0.1;
function sceneState(s,t){
  if(t<s.a)return null;
  const nx=s.next, end=nx?nx.a:DUR+1, u=t-s.a; let o=1,sc=1;
  if(s.in==='zoom'){ o=eio(u/XF); sc=1+0.07*(1-S(u,14,0.95)); }
  else if(s.in==='match'){ o=eio(u/0.12); sc=1+0.03*(1-S(u,12,1)); }
  else if(s.in==='dawn'){ o=eio(u/0.55); sc=1+0.03*(1-S(u,8,1)); }
  if(nx){ if(t>=end+(nx.in==='dawn'?0.6:0.12))return null;
    if(nx.in==='zoom'){ const z=(t-(end-0.2))/0.3; if(z>0) sc*=1+0.06*ei(z); } }
  return {o,sc};
}
const SCIDS=[...new Set(SC.map(s=>s.id))];
let GFX=0; // 1 while the graphic background is the top scene
function scenes(t){
  const st={};
  SC.forEach((s,i)=>{const r=sceneState(s,t); if(r)st[s.id]={r,s,i};});
  for(const id of SCIDS) if(!st[id]) $(id).style.opacity='0';
  GFX=0;
  for(const id in st){const {r,s,i}=st[id]; const e=$(id);
    e.style.zIndex=String(i+1); e.style.opacity=r.o.toFixed(4); e.style.transform=`scale(${r.sc.toFixed(4)})`;
    if(id==='sc-gfx'){ const top=Object.values(st).every(x=>x.i<=i); if(top)GFX=r.o;
      $('gbg').style.transform=`translate(${f2(20*Math.sin(t*0.4))}px,${f2(16*Math.cos(t*0.33))}px) scale(${(1.02+0.02*Math.sin(t*0.5)).toFixed(4)})`; }
    if(s.kb){ const uu=clamp((t-s.a)/Math.max(0.3,(Math.min(s.b,DUR)-s.a)));
      const k=lerp(s.k0,s.k1,eio(0.1+0.9*uu)), rr=lerp(s.r0,s.r1,uu);
      const dx=8*Math.sin(t*1.5+s.a), dy=6*Math.cos(t*1.2+s.a);
      $(s.kb).style.transform=`translate(${f2(dx)}px,${f2(s.ty+dy)}px) rotate(${rr.toFixed(3)}deg) scale(${k.toFixed(5)})`; }
  }
  // hook: soft screen light on the face, gently flickering (no flash)
  $('scrglow').style.opacity=(0.55+0.18*Math.sin(t*7.3)+0.1*Math.sin(t*13.1+1)).toFixed(3);
  $('scrglow').style.transform=`scale(${(1+0.04*Math.sin(t*5)).toFixed(4)})`;
}

// ---------- stars (graphic bg) + dust (everywhere) ----------
const STARS=[...Array(46)].map((_,i)=>({e:el('circle',{fill:i%5?'#F3EBDD':'#FFB366'},$('stars')),x:rnd(i)*1080,y:rnd(i+50)*1920,r:1.5+rnd(i+90)*3.2,ph:rnd(i+7)*6.28,sp:0.6+rnd(i+3)*1.6}));
const BOK=[[220,420,180],[860,1300,240],[760,300,150]].map(([x,y,r],i)=>({e:el('circle',{fill:'url(#ambg)'},$('stars')),x,y,r,i}));
const DUST=[...Array(20)].map((_,i)=>({e:el('circle',{fill:i%3?'#F3EBDD':'#FFB366'},$('dust')),x:rnd(i+200)*1080,y:rnd(i+300)*1920,r:2+rnd(i+400)*5,sp:14+rnd(i+500)*26,ph:rnd(i+600)*6.28}));
function particles(t){
  if(GFX>0) STARS.forEach(s=>{s.e.setAttribute('cx',f2(s.x+10*Math.sin(t*0.3+s.ph)));s.e.setAttribute('cy',f2((s.y-t*8*s.sp+1920*4)%1920));
    s.e.setAttribute('r',f2(s.r)); s.e.setAttribute('opacity',(0.25+0.45*(0.5+0.5*Math.sin(t*s.sp*2+s.ph))).toFixed(3));});
  BOK.forEach(b=>{b.e.setAttribute('cx',f2(b.x+40*Math.sin(t*0.35+b.i)));b.e.setAttribute('cy',f2(b.y+30*Math.cos(t*0.3+b.i*2)));b.e.setAttribute('r',f2(b.r*(1+0.08*Math.sin(t*0.8+b.i))));b.e.setAttribute('opacity','0.22');});
  DUST.forEach(d=>{const y=((d.y-t*d.sp)%1920+1920)%1920; d.e.setAttribute('cx',f2(d.x+24*Math.sin(t*0.5+d.ph))); d.e.setAttribute('cy',f2(y)); d.e.setAttribute('r',f2(d.r));
    d.e.setAttribute('opacity',((0.12+0.22*(0.5+0.5*Math.sin(t*1.3+d.ph)))*(0.6+0.4*GFX)).toFixed(3));});
}

// ---------- hook title (frame 0, breathes 1.0 <-> 1.04) ----------
function title(t){
  const out=eo((t-(T.small-0.08))/0.14), o=(1-out).toFixed(3);
  $('title').style.opacity=o; $('tshade').style.opacity=o;
  const br=1+0.04*(0.5-0.5*Math.cos(t*2*Math.PI/1.1));
  ['tl1','tl2'].forEach((id,i)=>{$(id).style.transform=`translateY(${f2(3*Math.sin(t*2.6+i))}px) scale(${(br*(1+0.12*out)).toFixed(4)})`;});
  const p=$('pill'), w=p.offsetWidth||260;
  p.style.transform=`translate(${f2(540-w/2)}px,${f2(128+4*Math.sin(t*2.2))}px) scale(${(1+0.02*Math.sin(t*3.3)).toFixed(4)})`;
}

// ---------- the one shape ----------
const NP=120, TH=[...Array(NP)].map((_,i)=>i/NP*Math.PI*2);
const P=(v0,keys,def)=>track(v0,keys,def);
const sX=P(540,[[T.small,540],[T.tired,820,CAMF],[T.brain,540,MORPH],[T.room,300,CAMF],[T.clock,640,MORPH],[T.sleep,800,CAMF],[T.write,600,CAMF],[K.jot,470,SLOW],[T.phone_down,760,CAMF],[T.help,540,MORPH]]);
const sY=P(720,[[H.small,640,SOFTB],[T.tired,330,CAMF],[T.brain,640,MORPH],[T.room,400,CAMF],[T.clock,620,MORPH],[T.sleep,290,CAMF],[T.write,520,CAMF],[K.jot,975,SLOW],[T.phone_down,520,CAMF],[T.help,600,MORPH],[K.hit,690,HEAVY],[T.help2,620,MORPH],[T.ask,585,MORPH]]);
const sRX=P(0,[[T.small,150,SOFTB],[H.small,400,SOFTB],[T.tired,120,CAMF],[T.brain,400,MORPH],[T.room,125,CAMF],[T.loop,100,MORPH],[T.clock,250,MORPH],[K.big2,340,SOFTB],[T.sleep,190,CAMF],[T.morning,150,MORPH],[K.lighter,60,SLOW],[T.write,55,CAMF],[K.jot,22,SLOW],[T.phone_down,40,MORPH],[T.help,330,MORPH],[K.hit,370,HEAVY],[T.help2,445,MORPH],[T.ask,430,MORPH]]);
const sRY=P(0,[[T.small,118,SOFTB],[H.small,320,SOFTB],[T.tired,95,CAMF],[T.brain,300,MORPH],[T.room,100,CAMF],[T.loop,82,MORPH],[T.clock,200,MORPH],[K.big2,270,SOFTB],[T.sleep,150,CAMF],[T.morning,120,MORPH],[K.lighter,50,SLOW],[T.write,45,CAMF],[K.jot,18,SLOW],[T.phone_down,32,MORPH],[T.help,260,MORPH],[K.hit,225,HEAVY],[T.help2,255,MORPH],[T.ask,165,MORPH]]);
const sN=P(2,[[T.help2,6.5,MORPH],[T.ask,4.6,MORPH]]);
const sCloud=P(0.14,[[T.brain,0,MORPH],[T.room,0.14,MORPH],[T.help2,0,FAST]]);
const sGyri=P(0,[[T.brain,1,MORPH],[T.room,0,FAST]]);
const sTail=P(0,[[T.ask,1,SOFTB]]);
const sSolid=P(0,[[T.help2,1,MORPH]]);
const sHeavy=P(0,[[T.help,0.6,SLOW],[K.hit,1,HEAVY],[T.help2,0,MORPH]]);
const sWarm=P(0,[[T.morning,0.6,MORPH],[K.lighter,1,SLOW],[T.write,0.6,MORPH],[T.help,0,MORPH]]);
const sTrail=P(0,[[T.small,1,MORPH],[T.brain,0,FAST],[T.room,1,MORPH],[K.lighter,0.4,SLOW],[T.write,0,MORPH],[T.help,1,MORPH],[T.help2,0,FAST]]);
const sKnot=P(0,[[T.small,0.45,MORPH],[H.small,1,SOFTB],[T.tired,0.5,CAMF],[T.brain,0,FAST],[T.room,0.5,MORPH],[K.big2,1,SOFTB],[K.lighter,0.3,SLOW],[T.write,0,MORPH],[T.help,1,MORPH],[T.help2,0,FAST]]);
const sOp=P(1,[[K.jot,0.55,SLOW],[T.help,1,MORPH]]);
const sOrb=P(0,[[T.loop,1,MORPH],[T.clock,0,MORPH]]);
const sGlowHit=t=>{let v=0;[[H.small,1],[K.big2,0.8]].forEach(([h,a])=>{const u=t-h; if(u>0)v+=a*Math.exp(-3*u);}); return v;};
// knot: a tangled scribble, unit box
const KN=(()=>{let d='';for(let i=0;i<=220;i++){const u=i/220*Math.PI*2; const x=0.62*Math.sin(3*u)+0.32*Math.sin(7*u+1), y=0.55*Math.cos(2*u)+0.38*Math.cos(5*u+0.4); d+=(i?'L':'M')+(x*100).toFixed(1)+' '+(y*100).toFixed(1);} return d;})();
$('knot').setAttribute('d',KN); $('knot').setAttribute('stroke-dasharray','260 60');
function shapePath(cx,cy,rx,ry,n,cloud,gyri,tail,live,t){
  const pts=[];
  for(const th of TH){const c=Math.cos(th),s=Math.sin(th);
    let r=Math.pow(Math.pow(Math.abs(c)/rx,n)+Math.pow(Math.abs(s)/ry,n),-1/n);
    r*=1+cloud*(Math.pow(Math.abs(Math.cos(5*th+0.3+t*0.25)),0.6)-0.62);
    r*=1-gyri*0.12*Math.pow(Math.max(0,s),2); r*=1+gyri*(0.035*Math.sin(13*th+0.5)+0.02*Math.sin(23*th+1.3)+0.015*Math.sin(7*th)+0.05*(-c)*(c<0?1:0.3));
    r*=1+live*(0.016*Math.sin(3*th+1.9*t)+0.011*Math.sin(5*th-2.7*t));
    let dth=Math.atan2(Math.sin(th-2.15),Math.cos(th-2.15)); r+=tail*95*Math.exp(-Math.pow(dth/0.11,2));
    pts.push([cx+r*c,cy+r*s]);}
  // closed Catmull-Rom -> cubic beziers
  let d=`M${f2(pts[0][0])} ${f2(pts[0][1])}`;
  for(let i=0;i<NP;i++){const p0=pts[(i-1+NP)%NP],p1=pts[i],p2=pts[(i+1)%NP],p3=pts[(i+2)%NP];
    d+=`C${f2(p1[0]+(p2[0]-p0[0])/6)} ${f2(p1[1]+(p2[1]-p0[1])/6)} ${f2(p2[0]-(p3[0]-p1[0])/6)} ${f2(p2[1]-(p3[1]-p1[1])/6)} ${f2(p2[0])} ${f2(p2[1])}`;}
  return d+'Z';
}
const ORB={x:550,y:560,rx:340,ry:140};
const orbAng=t=>-0.6+7.2*eio((t-K.loop+0.15)/1.05)+0.6*(t-T.loop);
function shape(t){
  let cx=sX(t), cy=sY(t); const rx=Math.max(0.5,sRX(t)), ry=Math.max(0.5,sRY(t));
  const orb=clamp(sOrb(t)), ang=orbAng(t);
  cx=lerp(cx,ORB.x+ORB.rx*Math.cos(ang),orb); cy=lerp(cy,ORB.y+ORB.ry*Math.sin(ang),orb);
  const heavy=clamp(sHeavy(t)), solid=clamp(sSolid(t)), warm=clamp(sWarm(t));
  // bob: light bubbles float; heavy one sinks slowly
  cy+=(1-solid)*(lerp(10,4,heavy)*Math.sin(t*lerp(2.2,1.1,heavy)))+solid*5*Math.sin(t*2.4); cx+=(1-solid)*8*Math.sin(t*1.3);
  const sq=heavy*0.04*Math.sin(t*2.2);
  const d=shapePath(cx,cy,rx*(1+sq),ry*(1-sq),sN(t),Math.max(0,sCloud(t)),clamp(sGyri(t)),clamp(sTail(t)),1-0.6*solid,t);
  $('shP').setAttribute('d',d); $('shGlow').setAttribute('d',d); $('clipP').setAttribute('d',d);
  const fill=mixc(mixc(mixc('#F3EBDD','#FFD7A0',warm),'#2B3768',heavy),'#F6EEDF',solid);
  const stroke=mixc(mixc(mixc('#F3EBDD','#FFD7A0',warm),'#9AA6D6',heavy),'#FFB366',solid);
  const fo=lerp(lerp(0.13,0.88,heavy),0.97,solid);
  const P_=$('shP'); P_.setAttribute('fill',fill); P_.setAttribute('fill-opacity',fo.toFixed(3)); P_.setAttribute('stroke',stroke);
  P_.setAttribute('stroke-width',f2(lerp(6,8,solid)));
  const vis0=rx>1.5?1:0, O=clamp(sOp(t))*vis0;
  op($('shapeG'),O);
  op($('shGlow'),(0.14+0.35*sGlowHit(t)+0.1*warm)*(1-heavy*0.7)); $('shGlow').setAttribute('stroke-width',f2(26+30*sGlowHit(t)));
  // trail dots (thought trail), or followers on the orbit
  const tr=clamp(sTrail(t)), m=Math.min(rx,ry);
  [[$('tr1'),0.95,0.17,-0.45],[$('tr2'),1.55,0.1,-0.85]].forEach(([e,k,rr,da])=>{
    const mm=Math.min(m,140); let x=cx-rx*(k>1?0.5:0.35), y=cy+ry+mm*(k>1?0.62:0.28);
    x=lerp(x,ORB.x+ORB.rx*Math.cos(ang+da),orb); y=lerp(y,ORB.y+ORB.ry*Math.sin(ang+da),orb);
    e.setAttribute('cx',f2(x+4*Math.sin(t*2+k))); e.setAttribute('cy',f2(y+4*Math.cos(t*2.3+k))); e.setAttribute('r',f2(Math.max(0.1,Math.min(m,150)*rr*(1+0.08*Math.sin(t*3+k)))));
    e.setAttribute('stroke',stroke); e.setAttribute('fill',fill); op(e,tr*(1-solid));});
  // the worry knot inside
  const kn=clamp(sKnot(t),0,1.3), ks=m*0.0062*kn*(1+0.04*Math.sin(t*3));
  $('knotG').setAttribute('transform',`translate(${f2(cx)} ${f2(cy)}) rotate(${f2(t*14)}) scale(${Math.max(0.0001,ks).toFixed(4)})`);
  $('knot').setAttribute('stroke-dashoffset',f2(-t*140)); $('knot').setAttribute('stroke-width',f2(lerp(6,9,heavy)));
  $('knot').setAttribute('stroke',mixc('#FFB366','#E9D2B0',heavy*0.5)); op($('knot'),clamp(kn*3)*(1-solid));
  // card text (help2) and comment text (ask)
  const cv=vis(t,K.talk+0.06,T.ask,{lin:0.22,lout:0.12}), av=vis(t,K.now,null,{lin:0.2});
  op($('cardT'),cv.o); $('cardT').setAttribute('transform',`translate(${f2(cx)} ${f2(cy)}) scale(${(0.9+0.1*cv.a+0.03*Math.sin(Math.PI*clamp((t-K.expert)/0.35))*(t>K.expert?1:0)).toFixed(4)})`);
  // hotline pill: lives in the card, then slides out of it at the morph and stays to the end (y 860-940)
  const hv=vis(t,K.talk+0.06,null,{lin:0.22}), hm=S(t-T.ask,9,0.95), cs=0.9+0.1*hv.a;
  const hx=lerp(cx,540,hm), hy=lerp(cy+69*cs,900,hm), hw=lerp(660,760,hm), hh=lerp(98,80,hm);
  op($('hot'),hv.o); $('hot').setAttribute('transform',`translate(${f2(hx)} ${f2(hy+(t>T.ask?3*Math.sin((t-T.ask)*2.2)*hm:0))}) scale(${(cs*(1-hm)+hm).toFixed(4)})`);
  const R=$('hotR'); R.setAttribute('x',f2(-hw/2)); R.setAttribute('y',f2(-hh/2)); R.setAttribute('width',f2(hw)); R.setAttribute('height',f2(hh)); R.setAttribute('rx',f2(hh/2));
  R.setAttribute('fill',mixc('#0B1630','#2A2230',hm)); R.setAttribute('fill-opacity',lerp(1,0.88,hm).toFixed(3)); R.setAttribute('stroke-width',f2(4*hm)); R.setAttribute('stroke-opacity','0.55');
  $('hotT').setAttribute('font-size',f2(lerp(50,44,hm))); $('hotT').setAttribute('y',f2(lerp(18,15,hm))); $('hotN').setAttribute('font-size',f2(lerp(60,52,hm)));
  op($('askT'),av.o); $('askT').setAttribute('transform',`translate(${f2(cx)} ${f2(cy-4)}) scale(${(0.88+0.12*S(t-K.now,14,0.6)+0.04*Math.sin(Math.PI*clamp((t-K.time)/0.35))*(t>K.time?1:0)).toFixed(4)})`);
}

// ---------- camera (graphic shots): brain -> emotion spot -> frontal brake ----------
const camS=track(1,[[T.brain,1.02,CAMF],[H.brain,1.12,CAM],[T.brake,1.16,CAM],[T.room,1,CAMF]]);
const camX=track(540,[[H.brain,600,CAM],[T.brake,360,CAM],[T.room,540,CAMF]]);
const camY=track(640,[[H.brain,730,CAM],[T.brake,560,CAM],[T.room,640,CAMF]]);
const punch=t=>{let v=0;[[H.small,0.05],[H.brain,0.05],[H.brake,0.035]].forEach(([h,a])=>{const u=t-h;if(u>0)v+=a*Math.exp(-4*u)*Math.sin(u*9);});return v;};
function camera(t){
  const s=camS(t)*(1+punch(t))*(1+0.008*Math.sin(t*1.7)), fx=camX(t)+5*Math.sin(t*1.1), fy=camY(t)+4*Math.cos(t*1.3);
  $('cam').setAttribute('transform',`translate(540 640) scale(${s.toFixed(5)}) translate(${f2(-fx)} ${f2(-fy)})`);
}

// ---------- brain internals ----------
const emo=track(0,[[T.brain+0.1,1,MORPH],[H.brain,1.6,SOFTB],[T.brake,1.2,SLOW]]);
const front=track(0,[[K.brake,1,MORPH],[H.brake,0.22,SLOW]]);
const gauge=track(1,[[H.brake,0.28,SLOW]]);
function brain(t){
  const v=vis(t,T.brain+0.05,T.room,{lin:0.25,lout:0.1}); op($('brainIn'),v.o); if(v.o<=0)return;
  const E=clamp(emo(t),0,2), fast=t>H.brain, per=fast?0.42:0.85, ph=((t-T.brain)%per+per)%per/per;
  const beat=Math.exp(-ph*5);
  $('emoGlow').setAttribute('r',f2(70+50*E+22*beat*E)); op($('emoGlow'),0.5*E+0.25*beat);
  $('emoCore').setAttribute('r',f2(18+10*E+6*beat)); op($('emoCore'),clamp(E));
  [['ring1',0],['ring2',0.5]].forEach(([id,o])=>{const u=((ph+o)%1); $(id).setAttribute('r',f2(40+(fast?150:90)*eo(u))); op($(id),(1-u)*clamp(E)*(fast?0.9:0.5));});
  const F=clamp(front(t)); op($('front'),F*(0.9+0.1*Math.sin(t*5))); $('front').setAttribute('r',f2(200+30*F));
  op($('labEmo'),vis(t,W.brain+0.25,null,{lin:0.2}).o);
  $('labEmo').setAttribute('transform',`translate(0 ${f2(3*Math.sin(t*3))})`);
  const bg=vis(t,K.brake,null,{lin:0.2}); op($('brakeG'),bg.o);
  const g=clamp(gauge(t),0.05,1); $('gauge').setAttribute('width',f2(208*g)); $('gauge').setAttribute('fill',mixc('#F3EBDD','#6B7AB0',1-g));
  $('sulci').setAttribute('stroke-dasharray','400 400'); $('sulci').setAttribute('stroke-dashoffset',f2(400*(1-eo((t-T.brain-0.05)/0.5))));
}

// ---------- head + orbit (loop) ----------
function head(t){
  const v=vis(t,T.loop+0.02,T.clock,{lin:0.22,lout:0.2}); op($('head'),v.o); if(v.o<=0)return;
  $('head').setAttribute('transform',`translate(0 ${f2(30*(1-S(t-T.loop,10,0.9))+4*Math.sin(t*2))})`);
  op($('headGlow'),0.3+0.2*Math.sin(t*6)); $('headGlow').setAttribute('r',f2(140+16*Math.sin(t*6)));
  const ov=eo((t-K.loop+0.1)/0.3); op($('orbit'),0.7*ov); $('orbit').setAttribute('stroke-dashoffset',f2(-t*260));
}

// ---------- phone put face down ----------
const tLand=K.phone2+0.2;
function phone(t){
  const v=vis(t,T.phone_down+0.02,T.help,{lin:0.16,lout:0.2}); op($('phoneG'),v.o); if(v.o<=0)return;
  const phi=Math.PI*eio((t-(K.put+0.04))/(tLand-K.put-0.04)), lift=-130*Math.sin(phi), c=Math.cos(phi);
  const land=t>tLand?Math.exp(-9*(t-tLand))*Math.sin((t-tLand)*28):0;
  $('phone').setAttribute('transform',`translate(${f2(430+20*Math.sin(phi))} ${f2(872+lift+6*land)}) rotate(${f2(-6*Math.sin(phi))}) scale(1 ${Math.abs(c)<0.02?0.02*Math.sign(c||1):c.toFixed(4)})`);
  const scr=clamp(c)*(0.85+0.15*Math.sin(t*9));
  op($('phScr'),c>0?1:0); op($('phBack'),c<0?1:0); $('phScr').setAttribute('fill',mixc('#2A3768','#CFE0FF',clamp(c)));
  op($('scrGlow'),scr); $('scrGlow').setAttribute('cx',f2(430+20*Math.sin(phi))); $('scrGlow').setAttribute('cy',f2(760+lift));
  const L=0.75+0.25*eo((t-tLand)/0.5); op($('lampGlow'),L*(0.92+0.08*Math.sin(t*2.1))); $('lampGlow').setAttribute('rx',f2(440+60*L));
}

// ---------- clock (03:00 at the "3 a.m." line, walking at the end) ----------
const TICKS=$('ticks'); for(let i=0;i<12;i++){const a=i*Math.PI/6; el('path',{d:`M${f2(78*Math.sin(a))} ${f2(-78*Math.cos(a))} L${f2((i%3?86:90)*Math.sin(a))} ${f2(-(i%3?86:90)*Math.cos(a))}`},TICKS);}
const clkX=track(250,[[T.ask,540,CAMF]]), clkY=track(360,[[T.ask,290,CAMF]]);
function clock(t){
  const a=vis(t,T.clock+0.02,T.sleep,{lin:0.22,lout:0.1}).o, b=vis(t,T.ask+0.1,null,{lin:0.22}).o, o=Math.max(a,b); op($('clk'),o); if(o<=0)return;
  const s=t<T.sleep+0.2?(0.6+0.4*S(t-T.clock,13,0.6))*1.15:(0.6+0.4*S(t-T.ask-0.1,13,0.6));
  $('clk').setAttribute('transform',`translate(${f2(clkX(t))} ${f2(clkY(t)+5*Math.sin(t*2.2))}) rotate(${f2(2*Math.sin(t*1.6))}) scale(${s.toFixed(4)})`);
  const walking=t>T.ask, w=walking?(t-T.ask):0;
  const minA=walking?w*40:0, hourA=90+minA/12;
  const step=walking?0.5:1, n=Math.floor(t/step), fr=t/step-n, secA=(n+S(fr*step,30,0.45))*(walking?12:6);
  $('hHour').setAttribute('transform',`rotate(${f2(hourA)})`); $('hMin').setAttribute('transform',`rotate(${f2(minA)})`); $('hSec').setAttribute('transform',`rotate(${f2(secA)})`);
  op($('clkT'),walking?0:1);
}

// ---------- captions: spring in on the word ----------
const capEls=CAPT.map((s,i)=>$('c'+i).querySelector('span'));
function captions(t){
  let i=-1; for(let k=0;k<CAPT.length;k++) if(t>=CAPT[k]) i=k;
  if(i<0) return; const tau=t-CAPT[i]; const a=S(tau,26,0.7);
  capEls[i].style.transform=`translateY(${f2(18*(1-a))}px) scale(${(0.84+0.16*a).toFixed(4)})`;
}

function render(t){ scenes(t); particles(t); title(t); camera(t); brain(t); head(t); phone(t); shape(t); clock(t); captions(t); }
const proxy={_t:0}; Object.defineProperty(proxy,'t',{get(){return this._t;},set(v){this._t=v;render(v);}});
const tl=gsap.timeline({paused:true});
tl.to(proxy,{t:%%DUR%%,duration:%%DUR%%,ease:'none'},0);
render(0);
window.__timelines=window.__timelines||{}; window.__timelines["main"]=tl;
})();
</script>
</body></html>
