// print shot list (id,t0,t1) from episode.js -> anime/shots.json (used by mix.py and contact sheets)
global.window={};global.document={};const fs=require("fs");const dir=__dirname;
global.DATA=JSON.parse(fs.readFileSync(dir+"/episode-data.json"));global.A={ease:t=>t,lerp:(a,b,t)=>a+(b-a)*t,spring:()=>1};
eval(fs.readFileSync(dir+"/episode.js","utf8")+";global.EP=EP;");
const s=EP.shots.map(s=>({id:s.id,t0:+s.t0.toFixed(3),t1:+Math.min(s.t1,DATA.duration).toFixed(3)}));
fs.writeFileSync(dir+"/shots.json",JSON.stringify(s,null,1));console.log(s.map(x=>((x.t0+x.t1)/2).toFixed(2)).join(","));
