import fs from 'fs';import {feature} from 'topojson-client';import * as d3 from 'd3-geo';
const topo=JSON.parse(fs.readFileSync('node_modules/world-atlas/countries-50m.json'));
const fc=feature(topo,topo.objects.countries);
const SEA={'Thailand':'th','Myanmar':'mm','Laos':'la','Cambodia':'kh','Vietnam':'vn','Malaysia':'my','Singapore':'sg','Indonesia':'id','Philippines':'ph','Brunei':'bn','Timor-Leste':'tl','China':'cn','India':'in','Bangladesh':'bd'};
const out={};
// SEA view 1080x1150
const sea=fc.features.filter(f=>SEA[f.properties.name]);
const box={type:'MultiPoint',coordinates:[[91, -10], [127, -10], [127, 28], [91, 28]]};
const p1=d3.geoMercator().fitExtent([[20,20],[1060,1130]],box);const g1=d3.geoPath(p1).digits(1);
out.sea={w:1080,h:1150,countries:{}};
for(const f of sea){out.sea.countries[SEA[f.properties.name]]=g1(f);}
// Thailand detailed + centroid
out.sea.th_centroid=p1(d3.geoCentroid(sea.find(f=>f.properties.name==='Thailand')));
// zoom view around Thailand 1080x1150
const box2={type:'MultiPoint',coordinates:[[95, 0.5], [110, 0.5], [110, 23], [95, 23]]};
const p2=d3.geoMercator().fitExtent([[20,20],[1060,1130]],box2);const g2=d3.geoPath(p2).digits(1);
out.zoom={w:1080,h:1150,countries:{}};
for(const f of sea){out.zoom.countries[SEA[f.properties.name]]=g2(f);}
// approx north Malay states: peninsular Malaysia clipped above lat 4.0 (approx, present-day)
const my=sea.find(f=>f.properties.name==='Malaysia');
const clip={type:'Polygon',coordinates:[[[99.5,4.0],[104,4.0],[104,6.8],[99.5,6.8],[99.5,4.0]]]};
// simple: provide clip rect in projected coords for editor (SVG clipPath)
const a=p2([99.5,6.8]),b=p2([104,4.0]);out.zoom.malay_north_clip={x:a[0],y:a[1],w:b[0]-a[0],h:b[1]-a[1],note:'approx Kedah/Perlis/Kelantan/Terengganu = peninsular Malaysia north of ~4.0N (present-day, approximate)'};
const topo2=JSON.parse(fs.readFileSync('node_modules/world-atlas/countries-110m.json'));const fc2=feature(topo2,topo2.objects.countries);
// world view 1080x700 (Natural Earth)
const asia={type:'MultiPoint',coordinates:[[40, 0], [148, 0], [148, 48], [40, 48]]};const p3=d3.geoMercator().fitExtent([[10,10],[1070,690]],asia);const g3=d3.geoPath(p3).digits(1);
out.world={w:1080,h:700,countries:{},pins:{}};
const W={'Thailand':'th','Bhutan':'bt','Nepal':'np','Iran':'ir','Japan':'jp'};
out.world.land=fc2.features.map(f=>g3(f)).filter(Boolean).join('');out.world.note='Asia crop lon40-148 lat0-48, Mercator';
for(const f of fc2.features){if(W[f.properties.name]){out.world.countries[W[f.properties.name]]=g3(f);out.world.pins[W[f.properties.name]]=p3(d3.geoCentroid(f));}}
out._source='Natural Earth via world-atlas@2 (public domain), d3-geo Mercator/NaturalEarth1; borders = present-day';
fs.writeFileSync('maps.json',JSON.stringify(out));
console.log(Object.keys(out.sea.countries),Object.keys(out.world.countries),fs.statSync('maps.json').size);
