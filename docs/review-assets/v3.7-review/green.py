import sys,glob,numpy as np
from PIL import Image
bad=[]
for f in sorted(glob.glob(sys.argv[1]+'/f*.png')):
    a=np.asarray(Image.open(f).convert('RGB')).astype(int)
    g=((a[...,1]>200)&(a[...,0]<80)&(a[...,2]<80)).sum()
    if g>int(sys.argv[2] if len(sys.argv)>2 else 3): bad.append((f.split('/')[-1],int(g)))
print('frames',len(glob.glob(sys.argv[1]+'/f*.png')),'with green',len(bad)); print(bad[:40])
