```python
import requests
import subprocess
import os
import boto3
from satsearch import Search
from datetime import datetime
import pandas as pd
import xarray
import rasterio
import rioxarray
from rasterio.plot import show
from rasterio.session import AWSSession
import pickle
import matplotlib.pyplot as plt
%matplotlib inline
import hvplot.xarray
import holoviews as hv
```









## Get and Set s3 Credentials


```python
def get_temp_creds():
    temp_creds_url = 'https://lpdaac.earthdata.nasa.gov/s3credentials'
    return requests.get(temp_creds_url).json()
```


```python
temp_creds_req = get_temp_creds()
#temp_creds_req
```


```python
session = boto3.Session(aws_access_key_id=temp_creds_req['accessKeyId'], 
                        aws_secret_access_key=temp_creds_req['secretAccessKey'],
                        aws_session_token=temp_creds_req['sessionToken'],
                        region_name='us-west-2')
```


```python
rio_env = rasterio.Env(AWSSession(session), 
                       GDAL_DISABLE_READDIR_ON_OPEN='TRUE', 
                       CPL_VSIL_CURL_ALLOWED_EXTENSIONS='tif', 
                       VSI_CACHE=True, 
                       region_name='us-west-2',
                       GDAL_HTTP_COOKIEFILE=os.path.expanduser('~/cookies.txt'),
                       GDAL_HTTP_COOKIEJAR=os.path.expanduser('~/cookies.txt'))
rio_env.__enter__()
```




    <rasterio.env.Env at 0x7f6ce2a33b50>



## Specify s3 and HTTPS URLS for Single File Access


```python
nasa_hls_s3_url = 's3://lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020191T172901.v1.5.B04.tif'

nasa_hls_http_url = 'https://lpdaac.earthdata.nasa.gov/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020191T172901.v1.5.B04.tif'
```

## Read Single HLS Tile

### s3 Data Access - Read Single File


```python
%%time
with rioxarray.open_rasterio(nasa_hls_s3_url, chunks=True) as src:
    ds = src.squeeze('band', drop=True)
    print(ds)
    fig, ax = plt.subplots(figsize=(8,8))
    show(ds, cmap='viridis', ax=ax)
```

    <xarray.DataArray (y: 3660, x: 3660)>
    dask.array<getitem, shape=(3660, 3660), dtype=int16, chunksize=(3660, 3660), chunktype=numpy.ndarray>
    Coordinates:
      * y            (y) float64 4.6e+06 4.6e+06 4.6e+06 ... 4.49e+06 4.49e+06
      * x            (x) float64 7e+05 7e+05 7e+05 ... 8.097e+05 8.097e+05 8.097e+05
        spatial_ref  int64 0
    Attributes:
        _FillValue:    -9999.0
        scale_factor:  0.0001
        add_offset:    0.0
        long_name:     Red
        grid_mapping:  spatial_ref
    CPU times: user 526 ms, sys: 104 ms, total: 630 ms
    Wall time: 3.19 s
    


    
![png](output_10_1.png)
    


### HTTPS Data Access - Read Single File


```python
%%time
with rioxarray.open_rasterio(nasa_hls_http_url, chunks=True) as src:
    ds = src.squeeze('band', drop=True)
    print(ds)
    fig, ax = plt.subplots(figsize=(8,8))
    show(ds, cmap='viridis', ax=ax)
```

    <xarray.DataArray (y: 3660, x: 3660)>
    dask.array<getitem, shape=(3660, 3660), dtype=int16, chunksize=(3660, 3660), chunktype=numpy.ndarray>
    Coordinates:
      * y            (y) float64 4.6e+06 4.6e+06 4.6e+06 ... 4.49e+06 4.49e+06
      * x            (x) float64 7e+05 7e+05 7e+05 ... 8.097e+05 8.097e+05 8.097e+05
        spatial_ref  int64 0
    Attributes:
        _FillValue:    -9999.0
        scale_factor:  0.0001
        add_offset:    0.0
        long_name:     Red
        grid_mapping:  spatial_ref
    CPU times: user 576 ms, sys: 143 ms, total: 719 ms
    Wall time: 2min 15s
    


    
![png](output_12_1.png)
    


---

### s3 Data Access - Read and Clip Single HLS Tile


```python
# Load polygon from disc
with open('./data/fsUTM', "rb") as poly_file:
    fsUTM = pickle.load(poly_file)
```


```python
%%time
with rioxarray.open_rasterio(nasa_hls_s3_url, chunks=True) as src:
    ds_clipped = src.squeeze('band', drop=True).rio.clip([fsUTM])
    print(ds_clipped)
    fig, ax = plt.subplots(figsize=(8,8))
    show(ds_clipped, cmap='viridis', ax=ax)
```

    <xarray.DataArray (y: 56, x: 56)>
    dask.array<astype, shape=(56, 56), dtype=int16, chunksize=(56, 56), chunktype=numpy.ndarray>
    Coordinates:
      * y            (y) float64 4.551e+06 4.551e+06 ... 4.549e+06 4.549e+06
      * x            (x) float64 7.796e+05 7.796e+05 ... 7.812e+05 7.812e+05
        spatial_ref  int64 0
    Attributes:
        scale_factor:  0.0001
        add_offset:    0.0
        long_name:     Red
        grid_mapping:  spatial_ref
        _FillValue:    -9999
    CPU times: user 531 ms, sys: 26.2 ms, total: 557 ms
    Wall time: 751 ms
    


    
![png](output_16_1.png)
    


### HTTPS Data Access - Read and Clip Single HLS Tile


```python
%%time
with rioxarray.open_rasterio(nasa_hls_http_url, chunks=True) as src:
    ds_clipped = src.squeeze('band', drop=True).rio.clip([fsUTM])
    print(ds_clipped)
    fig, ax = plt.subplots(figsize=(8,8))
    show(ds_clipped, cmap='viridis', ax=ax)
```

    <xarray.DataArray (y: 56, x: 56)>
    dask.array<astype, shape=(56, 56), dtype=int16, chunksize=(56, 56), chunktype=numpy.ndarray>
    Coordinates:
      * y            (y) float64 4.551e+06 4.551e+06 ... 4.549e+06 4.549e+06
      * x            (x) float64 7.796e+05 7.796e+05 ... 7.812e+05 7.812e+05
        spatial_ref  int64 0
    Attributes:
        scale_factor:  0.0001
        add_offset:    0.0
        long_name:     Red
        grid_mapping:  spatial_ref
        _FillValue:    -9999
    CPU times: user 606 ms, sys: 69.2 ms, total: 675 ms
    Wall time: 3.92 s
    


    
![png](output_18_1.png)
    


---

## Read HLS Time Series - `s3` vs `HTTPS` access

### s3 Data Access

**Pull URLS from static file. URL point to directly to assets within an `s3` bucket**


```python
with open('./data/files.txt') as txt:
    files = [l.strip() for l in txt.readlines()]
```


```python
files
```




    ['/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020191T172901.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020274T174141.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020279T174119.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020281T173211.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020284T174251.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020286T173259.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020289T174319.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020291T173331.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020294T174351.v1.5.B04.tif',
     '/vsis3/lp-prod-protected/HLSS30.015/HLS.S30.T13TGF.2020301T173431.v1.5.B04.tif']



**Use list of `s3` links to create `gdalbuildvrt` string with AWS credentials for `subprocces.call`**


```python
build_vrt = f"gdalbuildvrt data/stack.vrt -separate -input_file_list data/files.txt --config AWS_ACCESS_KEY_ID {temp_creds_req['accessKeyId']} --config AWS_SECRET_ACCESS_KEY {temp_creds_req['secretAccessKey']} --config AWS_SESSION_TOKEN {temp_creds_req['sessionToken']} --config GDAL_DISABLE_READDIR_ON_OPEN TRUE"
#build_vrt
```

**Execute gdalbuildvrt to construct a vrt on disk from the `s3` links**


```python
%%time
subprocess.call(build_vrt, shell=True)
```

    CPU times: user 0 ns, sys: 11.2 ms, total: 11.2 ms
    Wall time: 1.79 s
    




    0




```python
#files_s3 = [f.replace('/vsis3/', 's3://') for f in files]
#files_s3
```

**Read vrt in as xarray with dask backing**


```python
%%time
chunks=dict(band=1, x=1024, y=1024)
red = rioxarray.open_rasterio('./data/stack.vrt', chunks=chunks)
#red = rioxarray.open_rasterio('./data/stack.vrt')
red = red.rename({'band':'time'})
red['time'] = [datetime.strptime(x.split('.')[-5].split('T')[0], '%Y%j') for x in files]
red
```

    CPU times: user 64.4 ms, sys: 0 ns, total: 64.4 ms
    Wall time: 79 ms
    




<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 10, y: 3660, x: 3660)&gt;
dask.array&lt;open_rasterio-59b43edee37aad41b16ebeeaca90d085&lt;this-array&gt;, shape=(10, 3660, 3660), dtype=int16, chunksize=(1, 1024, 1024), chunktype=numpy.ndarray&gt;
Coordinates:
  * time         (time) datetime64[ns] 2020-07-09 2020-09-30 ... 2020-10-27
  * y            (y) float64 4.6e+06 4.6e+06 4.6e+06 ... 4.49e+06 4.49e+06
  * x            (x) float64 7e+05 7e+05 7e+05 ... 8.097e+05 8.097e+05 8.097e+05
    spatial_ref  int64 0
Attributes:
    _FillValue:    -9999.0
    scale_factor:  0.0001
    add_offset:    0.0
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 10</li><li><span class='xr-has-index'>y</span>: 3660</li><li><span class='xr-has-index'>x</span>: 3660</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-5348e9b4-363d-48a6-815f-7e7564466be8' class='xr-array-in' type='checkbox' checked><label for='section-5348e9b4-363d-48a6-815f-7e7564466be8' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>dask.array&lt;chunksize=(1, 1024, 1024), meta=np.ndarray&gt;</span></div><div class='xr-array-data'><table>
<tr>
<td>
<table>
  <thead>
    <tr><td> </td><th> Array </th><th> Chunk </th></tr>
  </thead>
  <tbody>
    <tr><th> Bytes </th><td> 267.91 MB </td> <td> 2.10 MB </td></tr>
    <tr><th> Shape </th><td> (10, 3660, 3660) </td> <td> (1, 1024, 1024) </td></tr>
    <tr><th> Count </th><td> 161 Tasks </td><td> 160 Chunks </td></tr>
    <tr><th> Type </th><td> int16 </td><td> numpy.ndarray </td></tr>
  </tbody>
</table>
</td>
<td>
<svg width="194" height="184" style="stroke:rgb(0,0,0);stroke-width:1" >

  <!-- Horizontal lines -->
  <line x1="10" y1="0" x2="24" y2="14" style="stroke-width:2" />
  <line x1="10" y1="33" x2="24" y2="48" />
  <line x1="10" y1="67" x2="24" y2="82" />
  <line x1="10" y1="100" x2="24" y2="115" />
  <line x1="10" y1="120" x2="24" y2="134" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="10" y1="0" x2="10" y2="120" style="stroke-width:2" />
  <line x1="11" y1="1" x2="11" y2="121" />
  <line x1="12" y1="2" x2="12" y2="122" />
  <line x1="14" y1="4" x2="14" y2="124" />
  <line x1="15" y1="5" x2="15" y2="125" />
  <line x1="17" y1="7" x2="17" y2="127" />
  <line x1="18" y1="8" x2="18" y2="128" />
  <line x1="20" y1="10" x2="20" y2="130" />
  <line x1="21" y1="11" x2="21" y2="131" />
  <line x1="23" y1="13" x2="23" y2="133" />
  <line x1="24" y1="14" x2="24" y2="134" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="10.0,0.0 24.9485979497544,14.948597949754403 24.9485979497544,134.9485979497544 10.0,120.0" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Horizontal lines -->
  <line x1="10" y1="0" x2="130" y2="0" style="stroke-width:2" />
  <line x1="11" y1="1" x2="131" y2="1" />
  <line x1="12" y1="2" x2="132" y2="2" />
  <line x1="14" y1="4" x2="134" y2="4" />
  <line x1="15" y1="5" x2="135" y2="5" />
  <line x1="17" y1="7" x2="137" y2="7" />
  <line x1="18" y1="8" x2="138" y2="8" />
  <line x1="20" y1="10" x2="140" y2="10" />
  <line x1="21" y1="11" x2="141" y2="11" />
  <line x1="23" y1="13" x2="143" y2="13" />
  <line x1="24" y1="14" x2="144" y2="14" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="10" y1="0" x2="24" y2="14" style="stroke-width:2" />
  <line x1="43" y1="0" x2="58" y2="14" />
  <line x1="77" y1="0" x2="92" y2="14" />
  <line x1="110" y1="0" x2="125" y2="14" />
  <line x1="130" y1="0" x2="144" y2="14" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="10.0,0.0 130.0,0.0 144.9485979497544,14.948597949754403 24.9485979497544,14.948597949754403" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Horizontal lines -->
  <line x1="24" y1="14" x2="144" y2="14" style="stroke-width:2" />
  <line x1="24" y1="48" x2="144" y2="48" />
  <line x1="24" y1="82" x2="144" y2="82" />
  <line x1="24" y1="115" x2="144" y2="115" />
  <line x1="24" y1="134" x2="144" y2="134" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="24" y1="14" x2="24" y2="134" style="stroke-width:2" />
  <line x1="58" y1="14" x2="58" y2="134" />
  <line x1="92" y1="14" x2="92" y2="134" />
  <line x1="125" y1="14" x2="125" y2="134" />
  <line x1="144" y1="14" x2="144" y2="134" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="24.9485979497544,14.948597949754403 144.9485979497544,14.948597949754403 144.9485979497544,134.9485979497544 24.9485979497544,134.9485979497544" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Text -->
  <text x="84.948598" y="154.948598" font-size="1.0rem" font-weight="100" text-anchor="middle" >3660</text>
  <text x="164.948598" y="74.948598" font-size="1.0rem" font-weight="100" text-anchor="middle" transform="rotate(-90,164.948598,74.948598)">3660</text>
  <text x="7.474299" y="147.474299" font-size="1.0rem" font-weight="100" text-anchor="middle" transform="rotate(45,7.474299,147.474299)">10</text>
</svg>
</td>
</tr>
</table></div></div></li><li class='xr-section-item'><input id='section-81205b29-4b0d-41fd-a31d-3fdf47bae459' class='xr-section-summary-in' type='checkbox'  checked><label for='section-81205b29-4b0d-41fd-a31d-3fdf47bae459' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2020-07-09 ... 2020-10-27</div><input id='attrs-2bb7b549-7a3e-4f1f-b663-92713e927dda' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-2bb7b549-7a3e-4f1f-b663-92713e927dda' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bddb8010-c7c0-4066-b8b1-b737314c3898' class='xr-var-data-in' type='checkbox'><label for='data-bddb8010-c7c0-4066-b8b1-b737314c3898' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;2020-07-09T00:00:00.000000000&#x27;, &#x27;2020-09-30T00:00:00.000000000&#x27;,
       &#x27;2020-10-05T00:00:00.000000000&#x27;, &#x27;2020-10-07T00:00:00.000000000&#x27;,
       &#x27;2020-10-10T00:00:00.000000000&#x27;, &#x27;2020-10-12T00:00:00.000000000&#x27;,
       &#x27;2020-10-15T00:00:00.000000000&#x27;, &#x27;2020-10-17T00:00:00.000000000&#x27;,
       &#x27;2020-10-20T00:00:00.000000000&#x27;, &#x27;2020-10-27T00:00:00.000000000&#x27;],
      dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.6e+06 4.6e+06 ... 4.49e+06</div><input id='attrs-6a0322fb-d994-4358-887e-84d1eb107dc0' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-6a0322fb-d994-4358-887e-84d1eb107dc0' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-1f347e07-1436-46cb-903f-8297b4fb082b' class='xr-var-data-in' type='checkbox'><label for='data-1f347e07-1436-46cb-903f-8297b4fb082b' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4600005., 4599975., 4599945., ..., 4490295., 4490265., 4490235.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>7e+05 7e+05 ... 8.097e+05 8.097e+05</div><input id='attrs-4a67b786-db06-42f4-9475-e584a2474a0f' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-4a67b786-db06-42f4-9475-e584a2474a0f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-5a224e43-0165-488b-9ae4-d32e80022f27' class='xr-var-data-in' type='checkbox'><label for='data-5a224e43-0165-488b-9ae4-d32e80022f27' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([699975., 700005., 700035., ..., 809685., 809715., 809745.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-a427682b-b037-4578-948e-f330269b6d89' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a427682b-b037-4578-948e-f330269b6d89' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-ed1e2dfc-644d-4109-9efe-0ed685842f5f' class='xr-var-data-in' type='checkbox'><label for='data-ed1e2dfc-644d-4109-9efe-0ed685842f5f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the WGS 84 ellipsoid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not_specified_based_on_WGS_84_spheroid</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>699960.0 30.0 0.0 4600020.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-80c2169d-ad19-4d53-a6e4-0b62025163f6' class='xr-section-summary-in' type='checkbox'  checked><label for='section-80c2169d-ad19-4d53-a6e4-0b62025163f6' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-9999.0</dd><dt><span>scale_factor :</span></dt><dd>0.0001</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>



### Clip the data to the field boundary (i.e., fsUTM) and load data into memory


```python
%%time
red_clipped = red.rio.clip([fsUTM]).load()
red_clipped
```

    CPU times: user 963 ms, sys: 113 ms, total: 1.08 s
    Wall time: 5.22 s
    




<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 10, y: 56, x: 56)&gt;
array([[[-9999, -9999, -9999, ...,  1865, -9999, -9999],
        [-9999, -9999, -9999, ...,  1825, -9999, -9999],
        [ 1473,  1710,  1689, ...,  1744, -9999, -9999],
        ...,
        [-9999, -9999,  1326, ...,  1106,  1233,  1246],
        [-9999, -9999,  1186, ..., -9999, -9999, -9999],
        [-9999, -9999,  1288, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1575, -9999, -9999],
        [-9999, -9999, -9999, ...,  1430, -9999, -9999],
        [ 1480,  1848,  1911, ...,  1401, -9999, -9999],
        ...,
        [-9999, -9999,  1652, ...,  2296,  2219,  2180],
        [-9999, -9999,  1600, ..., -9999, -9999, -9999],
        [-9999, -9999,  1547, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1704, -9999, -9999],
        [-9999, -9999, -9999, ...,  1457, -9999, -9999],
        [ 1442,  1787,  1779, ...,  1400, -9999, -9999],
        ...,
...
        ...,
        [-9999, -9999,  1921, ...,  2453,  2357,  2388],
        [-9999, -9999,  1852, ..., -9999, -9999, -9999],
        [-9999, -9999,  1814, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1675, -9999, -9999],
        [-9999, -9999, -9999, ...,  1460, -9999, -9999],
        [ 1425,  1573,  1596, ...,  1447, -9999, -9999],
        ...,
        [-9999, -9999,  1518, ...,  1922,  1859,  1830],
        [-9999, -9999,  1499, ..., -9999, -9999, -9999],
        [-9999, -9999,  1534, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  8310, -9999, -9999],
        [-9999, -9999, -9999, ...,  8435, -9999, -9999],
        [ 6690,  7765,  8133, ...,  7668, -9999, -9999],
        ...,
        [-9999, -9999,  8819, ...,  8577,  8601,  8661],
        [-9999, -9999,  8715, ..., -9999, -9999, -9999],
        [-9999, -9999,  8588, ..., -9999, -9999, -9999]]], dtype=int16)
Coordinates:
  * y            (y) float64 4.551e+06 4.551e+06 ... 4.549e+06 4.549e+06
  * x            (x) float64 7.796e+05 7.796e+05 ... 7.812e+05 7.812e+05
  * time         (time) datetime64[ns] 2020-07-09 2020-09-30 ... 2020-10-27
    spatial_ref  int64 0
Attributes:
    scale_factor:  0.0001
    add_offset:    0.0
    grid_mapping:  spatial_ref
    _FillValue:    -9999</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 10</li><li><span class='xr-has-index'>y</span>: 56</li><li><span class='xr-has-index'>x</span>: 56</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-f461d1a1-8994-4601-9dee-e597eb89af7e' class='xr-array-in' type='checkbox' checked><label for='section-f461d1a1-8994-4601-9dee-e597eb89af7e' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>-9999 -9999 -9999 -9999 -9999 -9999 ... -9999 -9999 -9999 -9999 -9999</span></div><div class='xr-array-data'><pre>array([[[-9999, -9999, -9999, ...,  1865, -9999, -9999],
        [-9999, -9999, -9999, ...,  1825, -9999, -9999],
        [ 1473,  1710,  1689, ...,  1744, -9999, -9999],
        ...,
        [-9999, -9999,  1326, ...,  1106,  1233,  1246],
        [-9999, -9999,  1186, ..., -9999, -9999, -9999],
        [-9999, -9999,  1288, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1575, -9999, -9999],
        [-9999, -9999, -9999, ...,  1430, -9999, -9999],
        [ 1480,  1848,  1911, ...,  1401, -9999, -9999],
        ...,
        [-9999, -9999,  1652, ...,  2296,  2219,  2180],
        [-9999, -9999,  1600, ..., -9999, -9999, -9999],
        [-9999, -9999,  1547, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1704, -9999, -9999],
        [-9999, -9999, -9999, ...,  1457, -9999, -9999],
        [ 1442,  1787,  1779, ...,  1400, -9999, -9999],
        ...,
...
        ...,
        [-9999, -9999,  1921, ...,  2453,  2357,  2388],
        [-9999, -9999,  1852, ..., -9999, -9999, -9999],
        [-9999, -9999,  1814, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1675, -9999, -9999],
        [-9999, -9999, -9999, ...,  1460, -9999, -9999],
        [ 1425,  1573,  1596, ...,  1447, -9999, -9999],
        ...,
        [-9999, -9999,  1518, ...,  1922,  1859,  1830],
        [-9999, -9999,  1499, ..., -9999, -9999, -9999],
        [-9999, -9999,  1534, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  8310, -9999, -9999],
        [-9999, -9999, -9999, ...,  8435, -9999, -9999],
        [ 6690,  7765,  8133, ...,  7668, -9999, -9999],
        ...,
        [-9999, -9999,  8819, ...,  8577,  8601,  8661],
        [-9999, -9999,  8715, ..., -9999, -9999, -9999],
        [-9999, -9999,  8588, ..., -9999, -9999, -9999]]], dtype=int16)</pre></div></div></li><li class='xr-section-item'><input id='section-921301eb-e1c3-43ba-ad26-9e2dee869435' class='xr-section-summary-in' type='checkbox'  checked><label for='section-921301eb-e1c3-43ba-ad26-9e2dee869435' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.551e+06 4.551e+06 ... 4.549e+06</div><input id='attrs-71142573-8e77-4c31-9d46-897748e4b702' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-71142573-8e77-4c31-9d46-897748e4b702' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-076e624d-4de8-4976-8174-d6e35c77ca5c' class='xr-var-data-in' type='checkbox'><label for='data-076e624d-4de8-4976-8174-d6e35c77ca5c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4551045., 4551015., 4550985., 4550955., 4550925., 4550895., 4550865.,
       4550835., 4550805., 4550775., 4550745., 4550715., 4550685., 4550655.,
       4550625., 4550595., 4550565., 4550535., 4550505., 4550475., 4550445.,
       4550415., 4550385., 4550355., 4550325., 4550295., 4550265., 4550235.,
       4550205., 4550175., 4550145., 4550115., 4550085., 4550055., 4550025.,
       4549995., 4549965., 4549935., 4549905., 4549875., 4549845., 4549815.,
       4549785., 4549755., 4549725., 4549695., 4549665., 4549635., 4549605.,
       4549575., 4549545., 4549515., 4549485., 4549455., 4549425., 4549395.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>7.796e+05 7.796e+05 ... 7.812e+05</div><input id='attrs-59709b0b-f6e4-44b2-85c9-dd9dbd63cc19' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-59709b0b-f6e4-44b2-85c9-dd9dbd63cc19' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-eb7e71e2-fe06-4c02-9522-4e8d806ec6fa' class='xr-var-data-in' type='checkbox'><label for='data-eb7e71e2-fe06-4c02-9522-4e8d806ec6fa' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([779595., 779625., 779655., 779685., 779715., 779745., 779775., 779805.,
       779835., 779865., 779895., 779925., 779955., 779985., 780015., 780045.,
       780075., 780105., 780135., 780165., 780195., 780225., 780255., 780285.,
       780315., 780345., 780375., 780405., 780435., 780465., 780495., 780525.,
       780555., 780585., 780615., 780645., 780675., 780705., 780735., 780765.,
       780795., 780825., 780855., 780885., 780915., 780945., 780975., 781005.,
       781035., 781065., 781095., 781125., 781155., 781185., 781215., 781245.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2020-07-09 ... 2020-10-27</div><input id='attrs-d2962916-9173-45ec-ba0b-0ea97389e1d4' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-d2962916-9173-45ec-ba0b-0ea97389e1d4' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-82d855c3-32fe-4d2d-9a98-ffaee608f8c9' class='xr-var-data-in' type='checkbox'><label for='data-82d855c3-32fe-4d2d-9a98-ffaee608f8c9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;2020-07-09T00:00:00.000000000&#x27;, &#x27;2020-09-30T00:00:00.000000000&#x27;,
       &#x27;2020-10-05T00:00:00.000000000&#x27;, &#x27;2020-10-07T00:00:00.000000000&#x27;,
       &#x27;2020-10-10T00:00:00.000000000&#x27;, &#x27;2020-10-12T00:00:00.000000000&#x27;,
       &#x27;2020-10-15T00:00:00.000000000&#x27;, &#x27;2020-10-17T00:00:00.000000000&#x27;,
       &#x27;2020-10-20T00:00:00.000000000&#x27;, &#x27;2020-10-27T00:00:00.000000000&#x27;],
      dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-aaf5d340-117f-4a67-b311-5aa0e2d9a59d' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-aaf5d340-117f-4a67-b311-5aa0e2d9a59d' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-16bf004d-babc-4cdf-8efb-19aeda2f5676' class='xr-var-data-in' type='checkbox'><label for='data-16bf004d-babc-4cdf-8efb-19aeda2f5676' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the WGS 84 ellipsoid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not_specified_based_on_WGS_84_spheroid</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>779580.0 30.0 0.0 4551060.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-9d47c43c-a03c-440a-bd27-bff5bb379d2b' class='xr-section-summary-in' type='checkbox'  checked><label for='section-9d47c43c-a03c-440a-bd27-bff5bb379d2b' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.0001</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd><dt><span>_FillValue :</span></dt><dd>-9999</dd></dl></div></li></ul></div></div>



### Plot the clipped time series


```python
red_clipped.hvplot.image(x='x', y='y', width=800, height=600, colorbar=True)
```






<div id='1002'>





  <div class="bk-root" id="814ad139-c8a4-4022-98d8-4691cccb2454" data-root-id="1002"></div>
</div>
<script type="application/javascript">(function(root) {
  function embed_document(root) {
    var docs_json = {"14c30858-7d86-4f80-aa14-60788e4ad285":{"defs":[{"extends":null,"module":null,"name":"DataModel","overrides":[],"properties":[]}],"roots":{"references":[{"attributes":{"color_mapper":{"id":"1037"},"dh":{"field":"dh"},"dw":{"field":"dw"},"image":{"field":"image"},"x":{"field":"x"},"y":{"field":"y"}},"id":"1041","type":"Image"},{"attributes":{"children":[{"id":"1087"},{"id":"1088"},{"id":"1092"}],"margin":[0,0,0,0],"name":"Column01592"},"id":"1086","type":"Column"},{"attributes":{},"id":"1051","type":"BasicTickFormatter"},{"attributes":{},"id":"1025","type":"PanTool"},{"attributes":{},"id":"1026","type":"WheelZoomTool"},{"attributes":{},"id":"1067","type":"NoOverlap"},{"attributes":{"high":9999,"low":-9999,"nan_color":"rgba(0, 0, 0, 0)","palette":["#3a4cc0","#3b4dc1","#3c4fc3","#3e51c4","#3f53c6","#4054c7","#4156c9","#4258ca","#435acc","#455bcd","#465dcf","#475fd0","#4860d1","#4962d3","#4b64d4","#4c66d6","#4d67d7","#4e69d8","#506bda","#516cdb","#526edc","#5370dd","#5571de","#5673e0","#5775e1","#5876e2","#5a78e3","#5b79e4","#5c7be5","#5d7de6","#5f7ee7","#6080e8","#6182ea","#6383ea","#6485eb","#6586ec","#6788ed","#6889ee","#698bef","#6b8df0","#6c8ef1","#6d90f1","#6f91f2","#7093f3","#7194f4","#7395f4","#7497f5","#7598f6","#779af6","#789bf7","#7a9df8","#7b9ef8","#7ca0f9","#7ea1f9","#7fa2fa","#80a4fa","#82a5fb","#83a6fb","#85a8fb","#86a9fc","#87aafc","#89acfc","#8aadfd","#8baefd","#8daffd","#8eb1fd","#90b2fe","#91b3fe","#92b4fe","#94b5fe","#95b7fe","#97b8fe","#98b9fe","#99bafe","#9bbbfe","#9cbcfe","#9dbdfe","#9fbefe","#a0bffe","#a2c0fe","#a3c1fe","#a4c2fe","#a6c3fd","#a7c4fd","#a8c5fd","#aac6fd","#abc7fc","#acc8fc","#aec9fc","#afcafb","#b0cbfb","#b2cbfb","#b3ccfa","#b4cdfa","#b6cef9","#b7cff9","#b8cff8","#b9d0f8","#bbd1f7","#bcd1f6","#bdd2f6","#bed3f5","#c0d3f5","#c1d4f4","#c2d4f3","#c3d5f2","#c5d5f2","#c6d6f1","#c7d6f0","#c8d7ef","#c9d7ee","#cad8ee","#ccd8ed","#cdd9ec","#ced9eb","#cfd9ea","#d0dae9","#d1dae8","#d2dae7","#d3dbe6","#d5dbe5","#d6dbe4","#d7dbe2","#d8dbe1","#d9dce0","#dadcdf","#dbdcde","#dcdcdd","#dddcdb","#dedbda","#dfdbd9","#e0dad7","#e1dad6","#e2d9d4","#e3d9d3","#e4d8d1","#e5d8d0","#e6d7cf","#e7d6cd","#e7d6cc","#e8d5ca","#e9d4c9","#ead3c7","#ebd3c6","#ecd2c4","#ecd1c3","#edd0c1","#edcfc0","#eecfbe","#efcebc","#efcdbb","#f0ccb9","#f1cbb8","#f1cab6","#f2c9b5","#f2c8b3","#f2c7b2","#f3c6b0","#f3c5af","#f4c4ad","#f4c3ab","#f4c2aa","#f5c1a8","#f5c0a7","#f5bfa5","#f6bda4","#f6bca2","#f6bba0","#f6ba9f","#f6b99d","#f6b79c","#f6b69a","#f7b598","#f7b397","#f7b295","#f7b194","#f7b092","#f7ae91","#f7ad8f","#f6ab8d","#f6aa8c","#f6a98a","#f6a789","#f6a687","#f6a486","#f6a384","#f5a182","#f5a081","#f59e7f","#f49d7e","#f49b7c","#f49a7b","#f39879","#f39678","#f39576","#f29375","#f29173","#f19072","#f18e70","#f08d6f","#f08b6d","#ef896c","#ee876a","#ee8669","#ed8467","#ec8266","#ec8064","#eb7f63","#ea7d61","#ea7b60","#e9795e","#e8775d","#e7755c","#e6745a","#e67259","#e57057","#e46e56","#e36c54","#e26a53","#e16852","#e06650","#df644f","#de624e","#dd604c","#dc5e4b","#db5c4a","#da5a48","#d95847","#d85646","#d75444","#d65243","#d44f42","#d34d40","#d24b3f","#d1493e","#cf463d","#ce443c","#cd423a","#cc3f39","#ca3d38","#c93b37","#c83835","#c63534","#c53233","#c43032","#c22d31","#c12a30","#bf282e","#be232d","#bc1f2c","#bb1a2b","#b9162a","#b81129","#b60d28","#b50827","#b30326"]},"id":"1037","type":"LinearColorMapper"},{"attributes":{"axis_label":"y coordinate of projection (metre)","formatter":{"id":"1054"},"major_label_policy":{"id":"1055"},"ticker":{"id":"1021"}},"id":"1020","type":"LinearAxis"},{"attributes":{},"id":"1047","type":"BasicTicker"},{"attributes":{"source":{"id":"1038"}},"id":"1046","type":"CDSView"},{"attributes":{"bottom_units":"screen","fill_alpha":0.5,"fill_color":"lightgrey","left_units":"screen","level":"overlay","line_alpha":1.0,"line_color":"black","line_dash":[4,4],"line_width":2,"right_units":"screen","syncable":false,"top_units":"screen"},"id":"1029","type":"BoxAnnotation"},{"attributes":{"end":4551060.0,"reset_end":4551060.0,"reset_start":4549380.0,"start":4549380.0,"tags":[[["y","y coordinate of projection","metre"]]]},"id":"1005","type":"Range1d"},{"attributes":{"margin":[5,5,5,5],"name":"VSpacer01590","sizing_mode":"stretch_height"},"id":"1087","type":"Spacer"},{"attributes":{},"id":"1052","type":"AllLabels"},{"attributes":{},"id":"1017","type":"BasicTicker"},{"attributes":{"margin":[5,5,5,5],"name":"HSpacer01594","sizing_mode":"stretch_width"},"id":"1085","type":"Spacer"},{"attributes":{},"id":"1024","type":"SaveTool"},{"attributes":{"color_mapper":{"id":"1037"},"dh":{"field":"dh"},"dw":{"field":"dw"},"image":{"field":"image"},"x":{"field":"x"},"y":{"field":"y"}},"id":"1049","type":"Image"},{"attributes":{"client_comm_id":"92bc2a51eb0d4edea0fba161fa1a6a08","comm_id":"b15c30dca8da495abc3616d341e80ec7","plot_id":"1002"},"id":"1127","type":"panel.models.comm_manager.CommManager"},{"attributes":{"active_multi":null,"tools":[{"id":"1006"},{"id":"1024"},{"id":"1025"},{"id":"1026"},{"id":"1027"},{"id":"1028"}]},"id":"1030","type":"Toolbar"},{"attributes":{"margin":[20,0,0,20],"name":"","style":{"white-space":"nowrap"},"text":"time: <b>2020-07-09 00:00:00</b>","width":250},"id":"1090","type":"Div"},{"attributes":{"children":[{"id":"1003"},{"id":"1007"},{"id":"1085"},{"id":"1086"}],"margin":[0,0,0,0],"name":"Row01577"},"id":"1002","type":"Row"},{"attributes":{"data_source":{"id":"1038"},"glyph":{"id":"1041"},"hover_glyph":null,"muted_glyph":null,"nonselection_glyph":{"id":"1043"},"selection_glyph":{"id":"1049"},"view":{"id":"1046"}},"id":"1045","type":"GlyphRenderer"},{"attributes":{"below":[{"id":"1016"}],"center":[{"id":"1019"},{"id":"1023"}],"left":[{"id":"1020"}],"margin":[5,5,5,5],"min_border_bottom":10,"min_border_left":10,"min_border_right":10,"min_border_top":10,"renderers":[{"id":"1045"}],"right":[{"id":"1048"}],"sizing_mode":"fixed","title":{"id":"1008"},"toolbar":{"id":"1030"},"width":800,"x_range":{"id":"1004"},"x_scale":{"id":"1012"},"y_range":{"id":"1005"},"y_scale":{"id":"1014"}},"id":"1007","subtype":"Figure","type":"Plot"},{"attributes":{"axis_label":"x coordinate of projection (metre)","formatter":{"id":"1051"},"major_label_policy":{"id":"1052"},"ticker":{"id":"1017"}},"id":"1016","type":"LinearAxis"},{"attributes":{"children":[{"id":"1089"}],"css_classes":["panel-widget-box"],"margin":[5,5,5,5],"name":"WidgetBox01578"},"id":"1088","type":"Column"},{"attributes":{"overlay":{"id":"1029"}},"id":"1027","type":"BoxZoomTool"},{"attributes":{"end":781260.0,"reset_end":781260.0,"reset_start":779580.0,"start":779580.0,"tags":[[["x","x coordinate of projection","metre"]]]},"id":"1004","type":"Range1d"},{"attributes":{"margin":[5,5,5,5],"name":"HSpacer01593","sizing_mode":"stretch_width"},"id":"1003","type":"Spacer"},{"attributes":{},"id":"1012","type":"LinearScale"},{"attributes":{"bar_line_color":"black","color_mapper":{"id":"1037"},"label_standoff":8,"location":[0,0],"major_label_policy":{"id":"1067"},"major_tick_line_color":"black","ticker":{"id":"1047"}},"id":"1048","type":"ColorBar"},{"attributes":{},"id":"1014","type":"LinearScale"},{"attributes":{"callback":null,"renderers":[{"id":"1045"}],"tags":["hv_created"],"tooltips":[["x coordinate of projection (metre)","$x"],["y coordinate of projection (metre)","$y"],["value","@image"]]},"id":"1006","type":"HoverTool"},{"attributes":{},"id":"1055","type":"AllLabels"},{"attributes":{},"id":"1021","type":"BasicTicker"},{"attributes":{"text":"time: 2020-07-09 00:00:00","text_color":"black","text_font_size":"12pt"},"id":"1008","type":"Title"},{"attributes":{"margin":[5,5,5,5],"name":"VSpacer01591","sizing_mode":"stretch_height"},"id":"1092","type":"Spacer"},{"attributes":{"axis":{"id":"1020"},"dimension":1,"grid_line_color":null,"ticker":null},"id":"1023","type":"Grid"},{"attributes":{},"id":"1028","type":"ResetTool"},{"attributes":{"data":{"dh":[1680.0],"dw":[1680.0],"image":[{"__ndarray__":"8djx2AgFrwbABsEG/QbYBlAGWAa7BqMGkgaBBpAGbwbeBmsGbAZJBpkFpAVnBU8F8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8diiBFQHegfaB6oHlweIB54HtweVB6QHnAfVB1gH2wjjCUcKlQlOCMEIwgmqCVQJJAn2CPIIVgh5B5gFYwV0BRwFKAUrBRsF9AStBJ0EDAVLBYUFigWbBWgFSwVCBXUFggXx2PHY8djx2PHY8djx2PHYLgVUB4AHyAerB4AHlweWB7AHjgeuB7IH0AfKBwEJMQpaCqQJiQnbCQMKUwriCQcK7AnqCbUJMAgsBD0E8AO2A+sDPQNnArsBbgFfAXsBigGVAa4BzAECAvIBewJuA1sEwAR/BEYEUgTRBN4E8djx2C4FZwd8B6oHoQeXB58HjQeUB5MHrge8B9oH2wf2CAUKIAp4CdcJkQnmCTAKDwoPCtsJ8AnGCd4H7gMqBOgDyQMTA8sBWQFPAUwBRAFBAT4BPAFEAUQBUAFLAVcBaAHpAbkCXgOnA+MD8QPrA/HY8dhvBX4HkAenB6cHoQeVB6UHrAeMB74HvwfsB+QHVgkQCjkKrgmxCbkJDwofCgcKFQrfCRkK2AmdB8oDyAOjA6ACfQFJAUMBQQFLAUoBRAFAAT4BPQFAAUUBPAFBAUcBUQFqAWoCmwOXA6sDBQTx2PHYIAWVB5UHnQeQB6UHoQecB6QHgAesB7EH+AfsB2EJ/gkxCosJfwl7Ce8JBgoAChAK0Qn2CbEJfwf6A3IDWwJiATwBNAEtAT0BOwE6AT0BOwE3AT0BQAFCATkBRgFGAUABSwFaAUkCcQPCA64E8djx2BQFjAeWB78Hmge3B6EHkgeRB2sHewefB/UH7Qd0Ce0JEApUCYgJtAkuCv0J+gn9CeYJAQrQCT0HwgOCAmMBNwEvATIBOAE5ATgBOAE1ATsBRwFDATgBPAE4ATkBQQFCAUsBRgFdAY0CHAQlBfHY8dhJBZIHpwfaB7UHrweLB5UHnwd9B24HgAfaB9IHOwnUCbkJIwmLCb0JJwoACrgJrwkOCtsJhQk2B1gDfwE3ASkBKAElAS0BKwE0ATUBOgFAATcBNgE8AUEBQwE6AUEBPAE9AT4BSAFzATID9gTx2PHYnwWEB6oH2gejB6kHpwe1B6cHfwehB58H7AfhB0cJsQmQCUEJ2gnUCS4K6QnzCc8J5wm2CZUJzAYYAk0BJgEkASgBKAEuASoBLAEzATsBNgE0AS8BOQE8ATQBNwE5ATkBNAE7AUEBRwH9AXgE8djx2E4FigeeB8AHngfGB70HwgepB4cHogehB/EH3QcGCTgJegl+Cc0JrwnlCagJzQl2CboJuAmiCSYGogFBASkBIwEjASYBJwEoASkBJwEvATgBMwE5ATQBNgEzATMBMAE3ATYBOgE/AUgBYQHYA/HY8di1BJQHrwfHB6wHxwecB6kHsgd9B7QHogffB9cHUgnKCJAJsQnJCbAJugmcCY4JYwm+CZ8JqQk7BXcBPAEoASIBKgEhAScBLQEoAScBMQE2ATYBNQE5AToBLgEyATcBOgE7ATQBOwFCAUwBrALx2PHYYgSFB5sHoQeJB6wHkgeiB5wHeweyB58HwQerB24JpgecCbEJtQl9Ca0JeAmUCY0J2QnDCZ8JPgRfAUIBKAEqAS0BJgEoASoBLAElAS4BNwE5ATUBNQE2ASwBMQEwATQBMAExATQBQAFJARgC8djx2D0EdAeIB4UHjgeoB5sHlgecB5oHngebB78H1AebCREIgAlzCXgJWQmzCYMJbQlmCbUJ0wlvCYsDXQFBASkBKgEoASgBJgErASwBKAEiASoBMwE0ATUBMQE0ATQBMgEyATABOQEwATkBQgELAvHY8dhzBGkHdQeHB5EHmgd1B5IHjAeGB5QHege3B/0H1glkCb4JfwlvCUUJbwmKCZYJiwmgCcEJKQkvA2EBRQEsAScBKAEwATEBMAFBASgBHQEmAUEBPQFBATgBMgE3ATABNgEzATIBOAE5AUQB6gHx2PHYoQR2B40HmQePB4sHdQeKB4gHdgeoB3MHowfoB9QJ5glSCXIJTwldCbEJtAnJCakJjgmUCdcIAgNbAUEBKwEmASkBLQEwAS8BOQEpASkBKQHDAVYBTQFFAUIBOQE2ATwBOQE5AT0BOgFBARMC8djx2NgEhQeVB4YHegeOB38Hfwd2B3EHmgd1B6EHzwd0CS8JNwlaCV4JnwnACb4JxAmxCQQKkwnDCLICWAFPATQBLgE3AUMBSAFEAUEBNgE2ASwBJAK8AaMBtwG5AbQBrgG/Ac0BxgHCAb0BywE8A/HY8dg2BXAHcQdnB2wHtgeFB3YHZwdiB38HhAelBw0IhAlQCVQJnAmhCZEJtgm8CcwJrgm4CX4JIwhoAlkBQwEyATEBMQE/ATkBNgEtASsBIwEkASkBQQE9AUABNwE2ATcBNQE2ATMBOwFCAUcBGgPx2PHY/gVNB2cHbQeFB9IHkwd6B1gHVwdoB50HrQf3B30JhwmCCagJjQmECbgJngm7CcAJpQl7CUwHDQJOAT4BMwEjASYBIQEnASUBJgEoAR0BHAEkATIBLgE1AS0BLwEvATMBNAE0AT8BOwFNAQ4D8djx2HQGQAdpB4AHeQeeB4oHjwdsB4IHlAeaB4gH/gebCZ0JjQm7CYEJiAmxCZUJtQmxCawJWwmqBw0CUQE6AS8BJQEmASUBJgEnASkBIwEmAScBJAEsATEBMwEtATABMAEtAS8BMgE0AT0BUwGWA/HY8divBkYHawdqB5gHxAe3B7AHjQd8B5UHhwdsB0cItAmvCYIJhAmeCYUJyQmqCa8JfQmrCZAJtghZAlcBPgEtASIBIwEnASgBJwEjASQBIAEeARwBJQE0AToBNwEyATEBOwEyATsBNQFBAX8BfwTx2PHYpgY+B1EHdwfFB6sHxwfhB4kHcAeHB5UHlwdlCJ8JfQktCW0Jkwl2CcYJpwmnCYYJmQmfCQ8J0gJaAUMBKwEiASUBKAEmASYBKQEjASkBJwEkASkBNQE1ATABMAExATMBMwE8ATgBQgHjAV4F8djx2M8GEQdPB78H0wdwBq4GmgdsB3YHnAecB6sHggiPCWEJDwlaCX8JegnACbMJxAmCCbgJrAkNCasDagFCAScBHgEeASkBJwEhASoBLAEpAR8BIwEhATABOgEzATgBOQE3AS4BOgE9AUsBQQJdBfHYoAQDB0wHYgeYB9cHoAc9B3kHQgdIB3IHewe5B6MIdQlKCW0JmgmMCYYJ0AmzCaYJdQm5CaMJ7ggUBAkCTgExASYBJwEnASsBKgErAS8BKgEjASkBJAEzAT4BNQE8ATkBNgE6ATYBPwFqAZADaQXx2BYEPAd+B00HVQd5B9cHdwdkB0UHWgduB4IHoweSCG8JbQloCZMJlAmhCdIJpwmiCYkJywmxCfQICARSA50BMAEoASQBKQEoASwBMAExASwBKwEpASUBLQFEAUIBNgE5ATsBOwFDAVUBPQJZBDAF8dgdBGYHRQdBB2kHfQd0B2YHYgdKB3QHewebB6QHwAhjCXoJXwmQCX0Jiwm0CZ4JsQmsCdMJ1wn2CHkE7APVAloBKAEnAR8BKwEoASsBJgEpAS8BKgEoASsBNwE+ATwBPwE+ATwBSQHVAeIDDQTx2PHYZAQzBwsHWQdlB44HiQdlB1sHQweHB5gHtwfEB6sIZwl1CWUJbwmDCYIJpgmOCcgJqAnaCc0J3QiOBNwDhwOYAmYBPgEtASUBKwElASMBKQEmASMBGQEiASoBNQE7AUoBPwFLAc0BngM/BEsE8djx2NsFDgcnBzIHYgcZB2AHaAdQB1EHgweZB5MHgQdyCE0JUwlXCWwJewlxCZIJhgmuCYIJyQnGCZYInwTyA88DpAP/Ap8BMAE0ASgBIgEoAR8BHAEZARcBHAEeAS0BQQE+AVcBCgKgAyEEQQR9BPHY8dixBYIGZAZDBqsFFAW/BTsG6AU4BsgFpwWcBb8FMwbuBiEHJwfgB1MIdwjUCPwIMAkiCVMJbwlMCDEF3wR6BCoEOQTcA3gCcgFKATQBMgEwAR0BKQEjASIBJwFAAUYBkgGOAqED2QMZBCcEWQTx2PHYCwX8BfgFHQVnBMgEQwX3BIIE9gPkAwgEEgRPBGEE7wPQA8sD7ANfBBIFUwa1BrEG7wbgBvcGVwbJBDUFTwV0BfwEHwXrBFMEcgRkA6MCmQKZAmoC9QHaAcYBMAISAxYE2gSxBPIDeATEBBAF8djx2FYFwgXlBDYEVAQKBZcEkgQtBMMD2wMnBPsDQQQ2BL4DnAOXA5IDlwPyAykFtAVOBk4GZwacBs8FzgQbBaMFAwULBQsF/wTlBJgFuAT7A08E4ATCBNgEsgQ3BLUERAWxBSsF+QQrBWoFmAXXBfHY8dibBcUFmARCBPYESQRKBGsEBAQBBO0DBgTeA+wDuAOcA7ADqgOTA6kDsAPGA1MEdAW9BUUGZAYRBm4FEQXUBIsE/QQlBXUEKwVGBegEYQQGBQMFKQUlBWIENgTdBBkFyAVuBe4EkQWJBcQFsAXx2PHYaQVnBZIEvQSiBAUFcQQ2BNwDxwOSA6MDzAOxA3kDegN9A4YDiQOHA3EDfgOxAyEEIAWbBlAGUwbIBdoEdAS5BM4EWgVIBPcEbgXSBPUEzAWfBN4EiQTmA4EE4ASLBGIFJwX+BE0FpwU8BYYF8djx2P0EAgXABFcETQR0BE4E1wOUA4QDlgOwA7IDggOFA2cDhwOHA0kDQwNLA7wDggNnAxUE5AVsBlEGmAXVBF4EQAVuBQYFbQRnBIkEaQSBBcwFTwU0BXoEpAQABcsErQRgBUsFLAXwBIMFFQWSBfHY8dhkBQQFfgTIA7wELgTXA8MDowNiA3YDmwOHA3MDegNcA3oDWwNRA2kDYAOVA4gDaAOyA7IENgb4BXYFKwX6BNoFXQXMBKQEyQS2BK0ETwWMBbkFYQVEBCkESgRmBOkEqAWMBSoFawVvBSkFPwXx2PHYVwUyBXQEkwS9BOMDqQO3A48DdgN3A3kDcANjA2QDbQN1A2MDZANdA4wDXAObA0gDWQPlA68FowUsBTMFJgURBbEEdAQ/BJ0EwQR5BLQE8wSmBZcFhgRuBHQEhgR+Bb4FUwWcBIkFZQVSBXAF8djx2CsFVgR6BAUElwN/A3YDdQNnA3IDXwOBA30DggN0A3UDWANjA3QDlANdA0YDWgNkA04DigOrBJAFUQUkBeUEhwRHBGUERgR4BPkEewR2BJEEywSnBbsENARFBIcEDAUlBa4EnQQwBVoFeAVVBfHY8djUBH8DeANXA3EDpwOXA44DVQNRA2MDSQNoA1YDPgNLA3IDcAOXA4UDXQNdA2YDjwNeA4EDFgRABfAEkQQHBRcF2wSgBIwEXQTTBKsEXwREBFUEKQVsBC0ESQQ8BL4E/AT2BHkECAUtBa4ERgXx2PHYYgSOA4QDbAPDAwYEmQN3A4MDaANYA20DngODA4YDfwN+A4YDcwNwA4gDYAN7A6wDhgOlA9IDCwXTBI0EWQXMBRIFsAQ+BB8EXARsBIQETATbBJ0EJgQDBC8EhgRFBRIFrARNBBUFiQRnBNgF8djx2FYEcgNzA54D+gOzA2YDWAOHA40DfgNUA6YDrQOZA68DfgOAA2wDcAO6A20DYwOIA4cDfwO0AwAFrQR+BA0FhQUoBXIEUgQEBBsEJwTPBGkEmwQDBBcEWQQJBegF1AXSBEwEcwQXBTsEhgRMBfHY8dgjBG0DcgOzA7ADaANoA0IDdAO2A5ADdAN/A58DmgNYA4UD6QOQA3EDbwNaA1MDagN8A2kDywMQBfAE7wQaBZMFXAWuBJQEjQReBFMEBgX8BMMEegSkBJcEMwXPBUUFqASFBKgEJwTGA/oDSwXx2PHYUAT5A9YDfgOqA5EDhANJA2gDiwOoA7QDqwPkBO8DeQOFA7cDhwObA1IDPANcA3YDeQN7A0AEtQVGBeAETgWpBRkFyASQBLwEjgSNBDsFOQXnBKUE6wR0BAUFQQX9BMAE0ARVBL8DpgNkBCQG8djx2P4DHQSUA2oD9gPaA2gDXgN7A7QDpgO3A7UDAASoA3EDggOjA9kDhgNgA1oDZgNxA3YDkgOEBBoHZwcgByYHQAcBB7cGgAacBlQGRQZDBvYF5AWjBdEFPAVeBVUFZgUcBfkELQTAA/sDTwV0BvHY8dhrBHMEfAOfA64DZANfA2UDXAOfA/UDpAOCA34D1wObA5IDkwPOA2YDYANjA3IDWANwA50DQwSxB/wHRghRCDAIowh3CB8IJAgdCDIIRwhBCFUINwgOCBkI+AfpByMILAjWB+0FXAaVB+UHtAfx2PHYKQTCAx8EqQNsA2gDfQN+A1gDCwS5A58DggPYA3kEfAQWBJgDdANYA1cDXwNQA0cDawNTA0EE3gcXCH4IvQjWCO8IXghUCF8IkQiiCI0ImwivCJIIfwhxCIEIgAiICJkIvgdaBucHQAgqCD4I8djx2FYEfQOZA10DTgN/A2sDdAM6A5ADewNiA4UDHgR0BJkEaASCA5wDhANVA2wDYwNcA6YDegM2BNkHTwjJCOQIsAggCQUJ4AjlCNAI9wi6CL0IsgiYCIoIcgh0CIQIeAieCIcHdQdPCEUIZwf3BfHY8djzBBMEbQNgA3cDUwNfA3UDZwNtA5QDkAPjA/8DegRjBP4DwgOxA6YDlANZA0gDhANjA5YD1ATlB8IGAwcTBy8HzwfECP8I5wghCS8JRQk1CU0JQAlVCYMJUAlbCUsJSwnsCNYI7wcVBtkEdgXx2PHY1gXzA2kDcwOxA1kDcgNaA4MDbANfA2cDswOVA+wD6AN+A6gDbQOQA2sDYwN5A2EDOAPLA0gGBggaBhUGEAYUBhUGWQbDBooGiQbFBuMGBAe9BnsGxAbcBvIGFQcWBygH1QcnB8QEwAQgBEcF8djx2FYGxwQRBHUDfANxA3IDegOAA3QDhgN1A50DQQN+A9IDhwOZA4IDiwOCA4cDlwNMA0wDhwQJBs8HEgYfBhMGCQYEBtAGWgWABG8E5QQVBRYFdQWrBeQGAAYSBvoF/gX+BeUGEQbIBFcE4ANDBfHYfQVGBmAFjAR1A5ADhgOAA38DfwNiA3oDkgN6Az4DXAOpA5cDqgO6A4cDpQPtA4YDdQPoA2gFVQbDBxcGEQYXBgkG/AUQB6IEXgOtA2MEMQRPBLUEgQSHBiAG/QXsBe4F9wUoB4oFdwSrBG8EZgXx2PQE6AUABkwFBwSLA5gDhwOUA5sDegN9A2sDcgMfAysDfAOrA9ADjQOLA40DoANRA7gD4QQ/BngGogcPBgkGFwYrBhkGogZUBJYDEwRPBEAEHQRxBJ0EowV0BuoF+QXuBfMFKQfWBcwEtgRtBDAF8djPBFYG+AX6BRcFMASaA4sDdQOTA44DkQOGA2QDJgM0A38DeQOeA3QDewNlA14DgwNxBO0FSgZ0BpcHGgYVBh8GLwY6BtEFygNBBDcESAQ5BP4D8AOrBJUEuwb9BRYGEwYGBk4GKAcoB0sHbQfx2PHYWAVaBvwFLQYhBmEFRgSeA5YDkwONA5YDkwOBA0sDXQN/A4sDfgNpA1cDcAOVA0MEswUJBjMGeAa8BzEGMwY6BjAGtgYHBU4E1ASmBIgEswSMBBwERQRUBJoG0gUdBicGGAYRBhAGAgYCBqwG8djx2PYFRAYYBmsGVAZbBlUFcgQMBMIDtwOGA5QDoQNuAywDXgOTA5UDgQO3A94DdwTmBT0GCwYfBnkGeAccBhQGHwYfBtUGRgRJBGoEzgRwBHYExASoBHUEVwRbBqgFDgYiBiMGFQYUBhgGHQa8BvHY8djBBa4GmQa+BpwGZgYoBrsFKgVFBZUEcgQ7BCYE5QPaAyEEyAS7BNoE0wQzBe8FWQZLBmEGfAa8BuIHcwZjBmUGUgbBBnUETAQlBHAEZAQ+BFEEJwQ3BGIE0AXJBfAFBAYHBhoGFgYSBg0G0Abx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY6AUYBj0GXAatBtcGWwcSCNcH4gfUB9MHBwdrBDgErwN3A9kDBwRmBEoEcgR0BHQG5AbnBtsG4AbPBr8GngaTBiEH8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8djx2PHY8dirBqgGBQcsBz8HPwdJB/HY8dg=","dtype":"int16","order":"little","shape":[56,56]}],"x":[779580.0],"y":[4549380.0]},"selected":{"id":"1039"},"selection_policy":{"id":"1073"}},"id":"1038","type":"ColumnDataSource"},{"attributes":{"children":[{"id":"1090"},{"id":"1091"}],"margin":[0,0,0,0],"min_width":290,"name":"Column01587","width":290},"id":"1089","type":"Column"},{"attributes":{},"id":"1054","type":"BasicTickFormatter"},{"attributes":{"end":9,"js_property_callbacks":{"change:value":[{"id":"1104"}]},"margin":[0,20,20,20],"min_width":250,"show_value":false,"start":0,"tooltips":false,"value":0,"width":250},"id":"1091","type":"Slider"},{"attributes":{},"id":"1073","type":"UnionRenderers"},{"attributes":{"color_mapper":{"id":"1037"},"dh":{"field":"dh"},"dw":{"field":"dw"},"global_alpha":0.1,"image":{"field":"image"},"x":{"field":"x"},"y":{"field":"y"}},"id":"1043","type":"Image"},{"attributes":{"args":{"bidirectional":false,"properties":{},"source":{"id":"1091"},"target":{"id":"1090"}},"code":"try { \n    var labels = ['time: <b>2020-07-09 00:00:00</b>', 'time: <b>2020-09-30 00:00:00</b>', 'time: <b>2020-10-05 00:00:00</b>', 'time: <b>2020-10-07 00:00:00</b>', 'time: <b>2020-10-10 00:00:00</b>', 'time: <b>2020-10-12 00:00:00</b>', 'time: <b>2020-10-15 00:00:00</b>', 'time: <b>2020-10-17 00:00:00</b>', 'time: <b>2020-10-20 00:00:00</b>', 'time: <b>2020-10-27 00:00:00</b>']\n    target.text = labels[source.value]\n     } catch(err) { console.log(err) }","tags":[140105595379600]},"id":"1104","type":"CustomJS"},{"attributes":{"axis":{"id":"1016"},"grid_line_color":null,"ticker":null},"id":"1019","type":"Grid"},{"attributes":{},"id":"1039","type":"Selection"}],"root_ids":["1002","1127"]},"title":"Bokeh Application","version":"2.3.0"}};
    var render_items = [{"docid":"14c30858-7d86-4f80-aa14-60788e4ad285","root_ids":["1002"],"roots":{"1002":"814ad139-c8a4-4022-98d8-4691cccb2454"}}];
    root.Bokeh.embed.embed_items_notebook(docs_json, render_items);
  }
  if (root.Bokeh !== undefined && root.Bokeh.Panel !== undefined) {
    embed_document(root);
  } else {
    var attempts = 0;
    var timer = setInterval(function(root) {
      if (root.Bokeh !== undefined && root.Bokeh.Panel !== undefined) {
        clearInterval(timer);
        embed_document(root);
      } else if (document.readyState == "complete") {
        attempts++;
        if (attempts > 100) {
          clearInterval(timer);
          console.log("Bokeh: ERROR: Unable to run BokehJS code because BokehJS library is missing");
        }
      }
    }, 10, root)
  }
})(window);</script>



### HTTPS Data Access


```python
files_https = [f.replace('/vsis3/', '/vsicurl/https://lpdaac.earthdata.nasa.gov/') for f in files]
```


```python
build_https_vrt = f"gdalbuildvrt data/stack_https.vrt -separate -input_file_list data/files_https.txt --config GDAL_HTTP_COOKIEFILE {os.path.expanduser('~/cookies.txt')} --config GDAL_HTTP_COOKIEJAR {os.path.expanduser('~/cookies.txt')} --config GDAL_DISABLE_READDIR_ON_OPEN TRUE"
#build_https_vrt
```

**Execute gdalbuildvrt to construct a vrt on disk from the `HTTPS` links**


```python
%%time
subprocess.call(build_https_vrt, shell=True)
```

    CPU times: user 27.8 ms, sys: 15.8 ms, total: 43.7 ms
    Wall time: 1min 18s
    




    0



**Read vrt in as xarray with dask backing**


```python
%%time
chunks=dict(band=1, x=1024, y=1024)
red_https = rioxarray.open_rasterio('./data/stack_https.vrt', chunks=chunks)
#red_https = rioxarray.open_rasterio('./data/stack.vrt')
red_https = red_https.rename({'band':'time'})
red_https['time'] = [datetime.strptime(x.split('.')[-5].split('T')[0], '%Y%j') for x in files]
red_https
```

    CPU times: user 58.5 ms, sys: 6.35 ms, total: 64.9 ms
    Wall time: 74 ms
    




<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 10, y: 3660, x: 3660)&gt;
dask.array&lt;open_rasterio-3c852e104a2890119afa510faa673fba&lt;this-array&gt;, shape=(10, 3660, 3660), dtype=int16, chunksize=(1, 1024, 1024), chunktype=numpy.ndarray&gt;
Coordinates:
  * time         (time) datetime64[ns] 2020-07-09 2020-09-30 ... 2020-10-27
  * y            (y) float64 4.6e+06 4.6e+06 4.6e+06 ... 4.49e+06 4.49e+06
  * x            (x) float64 7e+05 7e+05 7e+05 ... 8.097e+05 8.097e+05 8.097e+05
    spatial_ref  int64 0
Attributes:
    _FillValue:    -9999.0
    scale_factor:  0.0001
    add_offset:    0.0
    grid_mapping:  spatial_ref</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 10</li><li><span class='xr-has-index'>y</span>: 3660</li><li><span class='xr-has-index'>x</span>: 3660</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-1e43902e-3e6e-49ce-ac2a-22523186b5f4' class='xr-array-in' type='checkbox' checked><label for='section-1e43902e-3e6e-49ce-ac2a-22523186b5f4' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>dask.array&lt;chunksize=(1, 1024, 1024), meta=np.ndarray&gt;</span></div><div class='xr-array-data'><table>
<tr>
<td>
<table>
  <thead>
    <tr><td> </td><th> Array </th><th> Chunk </th></tr>
  </thead>
  <tbody>
    <tr><th> Bytes </th><td> 267.91 MB </td> <td> 2.10 MB </td></tr>
    <tr><th> Shape </th><td> (10, 3660, 3660) </td> <td> (1, 1024, 1024) </td></tr>
    <tr><th> Count </th><td> 161 Tasks </td><td> 160 Chunks </td></tr>
    <tr><th> Type </th><td> int16 </td><td> numpy.ndarray </td></tr>
  </tbody>
</table>
</td>
<td>
<svg width="194" height="184" style="stroke:rgb(0,0,0);stroke-width:1" >

  <!-- Horizontal lines -->
  <line x1="10" y1="0" x2="24" y2="14" style="stroke-width:2" />
  <line x1="10" y1="33" x2="24" y2="48" />
  <line x1="10" y1="67" x2="24" y2="82" />
  <line x1="10" y1="100" x2="24" y2="115" />
  <line x1="10" y1="120" x2="24" y2="134" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="10" y1="0" x2="10" y2="120" style="stroke-width:2" />
  <line x1="11" y1="1" x2="11" y2="121" />
  <line x1="12" y1="2" x2="12" y2="122" />
  <line x1="14" y1="4" x2="14" y2="124" />
  <line x1="15" y1="5" x2="15" y2="125" />
  <line x1="17" y1="7" x2="17" y2="127" />
  <line x1="18" y1="8" x2="18" y2="128" />
  <line x1="20" y1="10" x2="20" y2="130" />
  <line x1="21" y1="11" x2="21" y2="131" />
  <line x1="23" y1="13" x2="23" y2="133" />
  <line x1="24" y1="14" x2="24" y2="134" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="10.0,0.0 24.9485979497544,14.948597949754403 24.9485979497544,134.9485979497544 10.0,120.0" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Horizontal lines -->
  <line x1="10" y1="0" x2="130" y2="0" style="stroke-width:2" />
  <line x1="11" y1="1" x2="131" y2="1" />
  <line x1="12" y1="2" x2="132" y2="2" />
  <line x1="14" y1="4" x2="134" y2="4" />
  <line x1="15" y1="5" x2="135" y2="5" />
  <line x1="17" y1="7" x2="137" y2="7" />
  <line x1="18" y1="8" x2="138" y2="8" />
  <line x1="20" y1="10" x2="140" y2="10" />
  <line x1="21" y1="11" x2="141" y2="11" />
  <line x1="23" y1="13" x2="143" y2="13" />
  <line x1="24" y1="14" x2="144" y2="14" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="10" y1="0" x2="24" y2="14" style="stroke-width:2" />
  <line x1="43" y1="0" x2="58" y2="14" />
  <line x1="77" y1="0" x2="92" y2="14" />
  <line x1="110" y1="0" x2="125" y2="14" />
  <line x1="130" y1="0" x2="144" y2="14" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="10.0,0.0 130.0,0.0 144.9485979497544,14.948597949754403 24.9485979497544,14.948597949754403" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Horizontal lines -->
  <line x1="24" y1="14" x2="144" y2="14" style="stroke-width:2" />
  <line x1="24" y1="48" x2="144" y2="48" />
  <line x1="24" y1="82" x2="144" y2="82" />
  <line x1="24" y1="115" x2="144" y2="115" />
  <line x1="24" y1="134" x2="144" y2="134" style="stroke-width:2" />

  <!-- Vertical lines -->
  <line x1="24" y1="14" x2="24" y2="134" style="stroke-width:2" />
  <line x1="58" y1="14" x2="58" y2="134" />
  <line x1="92" y1="14" x2="92" y2="134" />
  <line x1="125" y1="14" x2="125" y2="134" />
  <line x1="144" y1="14" x2="144" y2="134" style="stroke-width:2" />

  <!-- Colored Rectangle -->
  <polygon points="24.9485979497544,14.948597949754403 144.9485979497544,14.948597949754403 144.9485979497544,134.9485979497544 24.9485979497544,134.9485979497544" style="fill:#ECB172A0;stroke-width:0"/>

  <!-- Text -->
  <text x="84.948598" y="154.948598" font-size="1.0rem" font-weight="100" text-anchor="middle" >3660</text>
  <text x="164.948598" y="74.948598" font-size="1.0rem" font-weight="100" text-anchor="middle" transform="rotate(-90,164.948598,74.948598)">3660</text>
  <text x="7.474299" y="147.474299" font-size="1.0rem" font-weight="100" text-anchor="middle" transform="rotate(45,7.474299,147.474299)">10</text>
</svg>
</td>
</tr>
</table></div></div></li><li class='xr-section-item'><input id='section-fba0ffdf-2d5a-482e-9168-ff4c5279ca1e' class='xr-section-summary-in' type='checkbox'  checked><label for='section-fba0ffdf-2d5a-482e-9168-ff4c5279ca1e' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2020-07-09 ... 2020-10-27</div><input id='attrs-13f8a6cb-f187-42fd-a877-d7a601be6d7a' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-13f8a6cb-f187-42fd-a877-d7a601be6d7a' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-92bba8dc-ea60-4fa6-8870-3b6b18f1fc5c' class='xr-var-data-in' type='checkbox'><label for='data-92bba8dc-ea60-4fa6-8870-3b6b18f1fc5c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;2020-07-09T00:00:00.000000000&#x27;, &#x27;2020-09-30T00:00:00.000000000&#x27;,
       &#x27;2020-10-05T00:00:00.000000000&#x27;, &#x27;2020-10-07T00:00:00.000000000&#x27;,
       &#x27;2020-10-10T00:00:00.000000000&#x27;, &#x27;2020-10-12T00:00:00.000000000&#x27;,
       &#x27;2020-10-15T00:00:00.000000000&#x27;, &#x27;2020-10-17T00:00:00.000000000&#x27;,
       &#x27;2020-10-20T00:00:00.000000000&#x27;, &#x27;2020-10-27T00:00:00.000000000&#x27;],
      dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.6e+06 4.6e+06 ... 4.49e+06</div><input id='attrs-f2ee05d6-5bbd-4fc4-8c99-ce6b23850462' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-f2ee05d6-5bbd-4fc4-8c99-ce6b23850462' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-a46ac3b8-ec80-480b-80c5-0dc9f5c9360f' class='xr-var-data-in' type='checkbox'><label for='data-a46ac3b8-ec80-480b-80c5-0dc9f5c9360f' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([4600005., 4599975., 4599945., ..., 4490295., 4490265., 4490235.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>7e+05 7e+05 ... 8.097e+05 8.097e+05</div><input id='attrs-bffa6801-26f1-4674-906e-7bf4784b033c' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-bffa6801-26f1-4674-906e-7bf4784b033c' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-99ff3962-02b7-4fba-9093-85347f5ebe21' class='xr-var-data-in' type='checkbox'><label for='data-99ff3962-02b7-4fba-9093-85347f5ebe21' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([699975., 700005., 700035., ..., 809685., 809715., 809745.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-a98da603-3c07-473f-b868-57dafd7e5ded' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-a98da603-3c07-473f-b868-57dafd7e5ded' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4f696b20-3d79-427c-ba64-8a58dfb38d01' class='xr-var-data-in' type='checkbox'><label for='data-4f696b20-3d79-427c-ba64-8a58dfb38d01' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the WGS 84 ellipsoid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not_specified_based_on_WGS_84_spheroid</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>699960.0 30.0 0.0 4600020.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-21dd16bf-2cc3-470d-b6c6-50e9f2eab939' class='xr-section-summary-in' type='checkbox'  checked><label for='section-21dd16bf-2cc3-470d-b6c6-50e9f2eab939' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>_FillValue :</span></dt><dd>-9999.0</dd><dt><span>scale_factor :</span></dt><dd>0.0001</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd></dl></div></li></ul></div></div>



### Clip the data to the field boundary (i.e., fsUTM) and load data into memory


```python
%%time
red_https_clipped = red_https.rio.clip([fsUTM]).load()
red_https_clipped
```

    CPU times: user 1.74 s, sys: 159 ms, total: 1.89 s
    Wall time: 1min 7s
    




<div><svg style="position: absolute; width: 0; height: 0; overflow: hidden">
<defs>
<symbol id="icon-database" viewBox="0 0 32 32">
<path d="M16 0c-8.837 0-16 2.239-16 5v4c0 2.761 7.163 5 16 5s16-2.239 16-5v-4c0-2.761-7.163-5-16-5z"></path>
<path d="M16 17c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
<path d="M16 26c-8.837 0-16-2.239-16-5v6c0 2.761 7.163 5 16 5s16-2.239 16-5v-6c0 2.761-7.163 5-16 5z"></path>
</symbol>
<symbol id="icon-file-text2" viewBox="0 0 32 32">
<path d="M28.681 7.159c-0.694-0.947-1.662-2.053-2.724-3.116s-2.169-2.030-3.116-2.724c-1.612-1.182-2.393-1.319-2.841-1.319h-15.5c-1.378 0-2.5 1.121-2.5 2.5v27c0 1.378 1.122 2.5 2.5 2.5h23c1.378 0 2.5-1.122 2.5-2.5v-19.5c0-0.448-0.137-1.23-1.319-2.841zM24.543 5.457c0.959 0.959 1.712 1.825 2.268 2.543h-4.811v-4.811c0.718 0.556 1.584 1.309 2.543 2.268zM28 29.5c0 0.271-0.229 0.5-0.5 0.5h-23c-0.271 0-0.5-0.229-0.5-0.5v-27c0-0.271 0.229-0.5 0.5-0.5 0 0 15.499-0 15.5 0v7c0 0.552 0.448 1 1 1h7v19.5z"></path>
<path d="M23 26h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 22h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
<path d="M23 18h-14c-0.552 0-1-0.448-1-1s0.448-1 1-1h14c0.552 0 1 0.448 1 1s-0.448 1-1 1z"></path>
</symbol>
</defs>
</svg>
<style>/* CSS stylesheet for displaying xarray objects in jupyterlab.
 *
 */

:root {
  --xr-font-color0: var(--jp-content-font-color0, rgba(0, 0, 0, 1));
  --xr-font-color2: var(--jp-content-font-color2, rgba(0, 0, 0, 0.54));
  --xr-font-color3: var(--jp-content-font-color3, rgba(0, 0, 0, 0.38));
  --xr-border-color: var(--jp-border-color2, #e0e0e0);
  --xr-disabled-color: var(--jp-layout-color3, #bdbdbd);
  --xr-background-color: var(--jp-layout-color0, white);
  --xr-background-color-row-even: var(--jp-layout-color1, white);
  --xr-background-color-row-odd: var(--jp-layout-color2, #eeeeee);
}

html[theme=dark],
body.vscode-dark {
  --xr-font-color0: rgba(255, 255, 255, 1);
  --xr-font-color2: rgba(255, 255, 255, 0.54);
  --xr-font-color3: rgba(255, 255, 255, 0.38);
  --xr-border-color: #1F1F1F;
  --xr-disabled-color: #515151;
  --xr-background-color: #111111;
  --xr-background-color-row-even: #111111;
  --xr-background-color-row-odd: #313131;
}

.xr-wrap {
  display: block;
  min-width: 300px;
  max-width: 700px;
}

.xr-text-repr-fallback {
  /* fallback to plain text repr when CSS is not injected (untrusted notebook) */
  display: none;
}

.xr-header {
  padding-top: 6px;
  padding-bottom: 6px;
  margin-bottom: 4px;
  border-bottom: solid 1px var(--xr-border-color);
}

.xr-header > div,
.xr-header > ul {
  display: inline;
  margin-top: 0;
  margin-bottom: 0;
}

.xr-obj-type,
.xr-array-name {
  margin-left: 2px;
  margin-right: 10px;
}

.xr-obj-type {
  color: var(--xr-font-color2);
}

.xr-sections {
  padding-left: 0 !important;
  display: grid;
  grid-template-columns: 150px auto auto 1fr 20px 20px;
}

.xr-section-item {
  display: contents;
}

.xr-section-item input {
  display: none;
}

.xr-section-item input + label {
  color: var(--xr-disabled-color);
}

.xr-section-item input:enabled + label {
  cursor: pointer;
  color: var(--xr-font-color2);
}

.xr-section-item input:enabled + label:hover {
  color: var(--xr-font-color0);
}

.xr-section-summary {
  grid-column: 1;
  color: var(--xr-font-color2);
  font-weight: 500;
}

.xr-section-summary > span {
  display: inline-block;
  padding-left: 0.5em;
}

.xr-section-summary-in:disabled + label {
  color: var(--xr-font-color2);
}

.xr-section-summary-in + label:before {
  display: inline-block;
  content: '►';
  font-size: 11px;
  width: 15px;
  text-align: center;
}

.xr-section-summary-in:disabled + label:before {
  color: var(--xr-disabled-color);
}

.xr-section-summary-in:checked + label:before {
  content: '▼';
}

.xr-section-summary-in:checked + label > span {
  display: none;
}

.xr-section-summary,
.xr-section-inline-details {
  padding-top: 4px;
  padding-bottom: 4px;
}

.xr-section-inline-details {
  grid-column: 2 / -1;
}

.xr-section-details {
  display: none;
  grid-column: 1 / -1;
  margin-bottom: 5px;
}

.xr-section-summary-in:checked ~ .xr-section-details {
  display: contents;
}

.xr-array-wrap {
  grid-column: 1 / -1;
  display: grid;
  grid-template-columns: 20px auto;
}

.xr-array-wrap > label {
  grid-column: 1;
  vertical-align: top;
}

.xr-preview {
  color: var(--xr-font-color3);
}

.xr-array-preview,
.xr-array-data {
  padding: 0 5px !important;
  grid-column: 2;
}

.xr-array-data,
.xr-array-in:checked ~ .xr-array-preview {
  display: none;
}

.xr-array-in:checked ~ .xr-array-data,
.xr-array-preview {
  display: inline-block;
}

.xr-dim-list {
  display: inline-block !important;
  list-style: none;
  padding: 0 !important;
  margin: 0;
}

.xr-dim-list li {
  display: inline-block;
  padding: 0;
  margin: 0;
}

.xr-dim-list:before {
  content: '(';
}

.xr-dim-list:after {
  content: ')';
}

.xr-dim-list li:not(:last-child):after {
  content: ',';
  padding-right: 5px;
}

.xr-has-index {
  font-weight: bold;
}

.xr-var-list,
.xr-var-item {
  display: contents;
}

.xr-var-item > div,
.xr-var-item label,
.xr-var-item > .xr-var-name span {
  background-color: var(--xr-background-color-row-even);
  margin-bottom: 0;
}

.xr-var-item > .xr-var-name:hover span {
  padding-right: 5px;
}

.xr-var-list > li:nth-child(odd) > div,
.xr-var-list > li:nth-child(odd) > label,
.xr-var-list > li:nth-child(odd) > .xr-var-name span {
  background-color: var(--xr-background-color-row-odd);
}

.xr-var-name {
  grid-column: 1;
}

.xr-var-dims {
  grid-column: 2;
}

.xr-var-dtype {
  grid-column: 3;
  text-align: right;
  color: var(--xr-font-color2);
}

.xr-var-preview {
  grid-column: 4;
}

.xr-var-name,
.xr-var-dims,
.xr-var-dtype,
.xr-preview,
.xr-attrs dt {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  padding-right: 10px;
}

.xr-var-name:hover,
.xr-var-dims:hover,
.xr-var-dtype:hover,
.xr-attrs dt:hover {
  overflow: visible;
  width: auto;
  z-index: 1;
}

.xr-var-attrs,
.xr-var-data {
  display: none;
  background-color: var(--xr-background-color) !important;
  padding-bottom: 5px !important;
}

.xr-var-attrs-in:checked ~ .xr-var-attrs,
.xr-var-data-in:checked ~ .xr-var-data {
  display: block;
}

.xr-var-data > table {
  float: right;
}

.xr-var-name span,
.xr-var-data,
.xr-attrs {
  padding-left: 25px !important;
}

.xr-attrs,
.xr-var-attrs,
.xr-var-data {
  grid-column: 1 / -1;
}

dl.xr-attrs {
  padding: 0;
  margin: 0;
  display: grid;
  grid-template-columns: 125px auto;
}

.xr-attrs dt,
.xr-attrs dd {
  padding: 0;
  margin: 0;
  float: left;
  padding-right: 10px;
  width: auto;
}

.xr-attrs dt {
  font-weight: normal;
  grid-column: 1;
}

.xr-attrs dt:hover span {
  display: inline-block;
  background: var(--xr-background-color);
  padding-right: 10px;
}

.xr-attrs dd {
  grid-column: 2;
  white-space: pre-wrap;
  word-break: break-all;
}

.xr-icon-database,
.xr-icon-file-text2 {
  display: inline-block;
  vertical-align: middle;
  width: 1em;
  height: 1.5em !important;
  stroke-width: 0;
  stroke: currentColor;
  fill: currentColor;
}
</style><pre class='xr-text-repr-fallback'>&lt;xarray.DataArray (time: 10, y: 56, x: 56)&gt;
array([[[-9999, -9999, -9999, ...,  1865, -9999, -9999],
        [-9999, -9999, -9999, ...,  1825, -9999, -9999],
        [ 1473,  1710,  1689, ...,  1744, -9999, -9999],
        ...,
        [-9999, -9999,  1326, ...,  1106,  1233,  1246],
        [-9999, -9999,  1186, ..., -9999, -9999, -9999],
        [-9999, -9999,  1288, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1575, -9999, -9999],
        [-9999, -9999, -9999, ...,  1430, -9999, -9999],
        [ 1480,  1848,  1911, ...,  1401, -9999, -9999],
        ...,
        [-9999, -9999,  1652, ...,  2296,  2219,  2180],
        [-9999, -9999,  1600, ..., -9999, -9999, -9999],
        [-9999, -9999,  1547, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1704, -9999, -9999],
        [-9999, -9999, -9999, ...,  1457, -9999, -9999],
        [ 1442,  1787,  1779, ...,  1400, -9999, -9999],
        ...,
...
        ...,
        [-9999, -9999,  1921, ...,  2453,  2357,  2388],
        [-9999, -9999,  1852, ..., -9999, -9999, -9999],
        [-9999, -9999,  1814, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1675, -9999, -9999],
        [-9999, -9999, -9999, ...,  1460, -9999, -9999],
        [ 1425,  1573,  1596, ...,  1447, -9999, -9999],
        ...,
        [-9999, -9999,  1518, ...,  1922,  1859,  1830],
        [-9999, -9999,  1499, ..., -9999, -9999, -9999],
        [-9999, -9999,  1534, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  8310, -9999, -9999],
        [-9999, -9999, -9999, ...,  8435, -9999, -9999],
        [ 6690,  7765,  8133, ...,  7668, -9999, -9999],
        ...,
        [-9999, -9999,  8819, ...,  8577,  8601,  8661],
        [-9999, -9999,  8715, ..., -9999, -9999, -9999],
        [-9999, -9999,  8588, ..., -9999, -9999, -9999]]], dtype=int16)
Coordinates:
  * y            (y) float64 4.551e+06 4.551e+06 ... 4.549e+06 4.549e+06
  * x            (x) float64 7.796e+05 7.796e+05 ... 7.812e+05 7.812e+05
  * time         (time) datetime64[ns] 2020-07-09 2020-09-30 ... 2020-10-27
    spatial_ref  int64 0
Attributes:
    scale_factor:  0.0001
    add_offset:    0.0
    grid_mapping:  spatial_ref
    _FillValue:    -9999</pre><div class='xr-wrap' hidden><div class='xr-header'><div class='xr-obj-type'>xarray.DataArray</div><div class='xr-array-name'></div><ul class='xr-dim-list'><li><span class='xr-has-index'>time</span>: 10</li><li><span class='xr-has-index'>y</span>: 56</li><li><span class='xr-has-index'>x</span>: 56</li></ul></div><ul class='xr-sections'><li class='xr-section-item'><div class='xr-array-wrap'><input id='section-dc96c09e-b873-495f-9de2-e2fab8ba57de' class='xr-array-in' type='checkbox' checked><label for='section-dc96c09e-b873-495f-9de2-e2fab8ba57de' title='Show/hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-array-preview xr-preview'><span>-9999 -9999 -9999 -9999 -9999 -9999 ... -9999 -9999 -9999 -9999 -9999</span></div><div class='xr-array-data'><pre>array([[[-9999, -9999, -9999, ...,  1865, -9999, -9999],
        [-9999, -9999, -9999, ...,  1825, -9999, -9999],
        [ 1473,  1710,  1689, ...,  1744, -9999, -9999],
        ...,
        [-9999, -9999,  1326, ...,  1106,  1233,  1246],
        [-9999, -9999,  1186, ..., -9999, -9999, -9999],
        [-9999, -9999,  1288, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1575, -9999, -9999],
        [-9999, -9999, -9999, ...,  1430, -9999, -9999],
        [ 1480,  1848,  1911, ...,  1401, -9999, -9999],
        ...,
        [-9999, -9999,  1652, ...,  2296,  2219,  2180],
        [-9999, -9999,  1600, ..., -9999, -9999, -9999],
        [-9999, -9999,  1547, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1704, -9999, -9999],
        [-9999, -9999, -9999, ...,  1457, -9999, -9999],
        [ 1442,  1787,  1779, ...,  1400, -9999, -9999],
        ...,
...
        ...,
        [-9999, -9999,  1921, ...,  2453,  2357,  2388],
        [-9999, -9999,  1852, ..., -9999, -9999, -9999],
        [-9999, -9999,  1814, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  1675, -9999, -9999],
        [-9999, -9999, -9999, ...,  1460, -9999, -9999],
        [ 1425,  1573,  1596, ...,  1447, -9999, -9999],
        ...,
        [-9999, -9999,  1518, ...,  1922,  1859,  1830],
        [-9999, -9999,  1499, ..., -9999, -9999, -9999],
        [-9999, -9999,  1534, ..., -9999, -9999, -9999]],

       [[-9999, -9999, -9999, ...,  8310, -9999, -9999],
        [-9999, -9999, -9999, ...,  8435, -9999, -9999],
        [ 6690,  7765,  8133, ...,  7668, -9999, -9999],
        ...,
        [-9999, -9999,  8819, ...,  8577,  8601,  8661],
        [-9999, -9999,  8715, ..., -9999, -9999, -9999],
        [-9999, -9999,  8588, ..., -9999, -9999, -9999]]], dtype=int16)</pre></div></div></li><li class='xr-section-item'><input id='section-7ddc938a-993a-4c7f-9660-5e484f5dc3b1' class='xr-section-summary-in' type='checkbox'  checked><label for='section-7ddc938a-993a-4c7f-9660-5e484f5dc3b1' class='xr-section-summary' >Coordinates: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><ul class='xr-var-list'><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>y</span></div><div class='xr-var-dims'>(y)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>4.551e+06 4.551e+06 ... 4.549e+06</div><input id='attrs-080438e1-e83e-490a-ae94-0d4e1418d7f9' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-080438e1-e83e-490a-ae94-0d4e1418d7f9' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-bb7e7e2b-5216-41c8-801d-77d363249af9' class='xr-var-data-in' type='checkbox'><label for='data-bb7e7e2b-5216-41c8-801d-77d363249af9' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>Y</dd><dt><span>long_name :</span></dt><dd>y coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_y_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([4551045., 4551015., 4550985., 4550955., 4550925., 4550895., 4550865.,
       4550835., 4550805., 4550775., 4550745., 4550715., 4550685., 4550655.,
       4550625., 4550595., 4550565., 4550535., 4550505., 4550475., 4550445.,
       4550415., 4550385., 4550355., 4550325., 4550295., 4550265., 4550235.,
       4550205., 4550175., 4550145., 4550115., 4550085., 4550055., 4550025.,
       4549995., 4549965., 4549935., 4549905., 4549875., 4549845., 4549815.,
       4549785., 4549755., 4549725., 4549695., 4549665., 4549635., 4549605.,
       4549575., 4549545., 4549515., 4549485., 4549455., 4549425., 4549395.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>x</span></div><div class='xr-var-dims'>(x)</div><div class='xr-var-dtype'>float64</div><div class='xr-var-preview xr-preview'>7.796e+05 7.796e+05 ... 7.812e+05</div><input id='attrs-c284696e-60d8-4f31-befb-329e8b10a51f' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-c284696e-60d8-4f31-befb-329e8b10a51f' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-4054524f-4e37-4517-b7a6-754aaba1c97c' class='xr-var-data-in' type='checkbox'><label for='data-4054524f-4e37-4517-b7a6-754aaba1c97c' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>axis :</span></dt><dd>X</dd><dt><span>long_name :</span></dt><dd>x coordinate of projection</dd><dt><span>standard_name :</span></dt><dd>projection_x_coordinate</dd><dt><span>units :</span></dt><dd>metre</dd></dl></div><div class='xr-var-data'><pre>array([779595., 779625., 779655., 779685., 779715., 779745., 779775., 779805.,
       779835., 779865., 779895., 779925., 779955., 779985., 780015., 780045.,
       780075., 780105., 780135., 780165., 780195., 780225., 780255., 780285.,
       780315., 780345., 780375., 780405., 780435., 780465., 780495., 780525.,
       780555., 780585., 780615., 780645., 780675., 780705., 780735., 780765.,
       780795., 780825., 780855., 780885., 780915., 780945., 780975., 781005.,
       781035., 781065., 781095., 781125., 781155., 781185., 781215., 781245.])</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span class='xr-has-index'>time</span></div><div class='xr-var-dims'>(time)</div><div class='xr-var-dtype'>datetime64[ns]</div><div class='xr-var-preview xr-preview'>2020-07-09 ... 2020-10-27</div><input id='attrs-b80a6186-11f1-4135-9727-3316be6fa420' class='xr-var-attrs-in' type='checkbox' disabled><label for='attrs-b80a6186-11f1-4135-9727-3316be6fa420' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-0b868962-0505-4319-93e0-8e4cfae01d12' class='xr-var-data-in' type='checkbox'><label for='data-0b868962-0505-4319-93e0-8e4cfae01d12' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'></dl></div><div class='xr-var-data'><pre>array([&#x27;2020-07-09T00:00:00.000000000&#x27;, &#x27;2020-09-30T00:00:00.000000000&#x27;,
       &#x27;2020-10-05T00:00:00.000000000&#x27;, &#x27;2020-10-07T00:00:00.000000000&#x27;,
       &#x27;2020-10-10T00:00:00.000000000&#x27;, &#x27;2020-10-12T00:00:00.000000000&#x27;,
       &#x27;2020-10-15T00:00:00.000000000&#x27;, &#x27;2020-10-17T00:00:00.000000000&#x27;,
       &#x27;2020-10-20T00:00:00.000000000&#x27;, &#x27;2020-10-27T00:00:00.000000000&#x27;],
      dtype=&#x27;datetime64[ns]&#x27;)</pre></div></li><li class='xr-var-item'><div class='xr-var-name'><span>spatial_ref</span></div><div class='xr-var-dims'>()</div><div class='xr-var-dtype'>int64</div><div class='xr-var-preview xr-preview'>0</div><input id='attrs-e33cd0e1-36e5-4da8-a3ca-a15d31628d59' class='xr-var-attrs-in' type='checkbox' ><label for='attrs-e33cd0e1-36e5-4da8-a3ca-a15d31628d59' title='Show/Hide attributes'><svg class='icon xr-icon-file-text2'><use xlink:href='#icon-file-text2'></use></svg></label><input id='data-f5a21641-1502-4c9b-b9f5-a7c0aec962b8' class='xr-var-data-in' type='checkbox'><label for='data-f5a21641-1502-4c9b-b9f5-a7c0aec962b8' title='Show/Hide data repr'><svg class='icon xr-icon-database'><use xlink:href='#icon-database'></use></svg></label><div class='xr-var-attrs'><dl class='xr-attrs'><dt><span>crs_wkt :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>semi_major_axis :</span></dt><dd>6378137.0</dd><dt><span>semi_minor_axis :</span></dt><dd>6356752.314245179</dd><dt><span>inverse_flattening :</span></dt><dd>298.257223563</dd><dt><span>reference_ellipsoid_name :</span></dt><dd>WGS 84</dd><dt><span>longitude_of_prime_meridian :</span></dt><dd>0.0</dd><dt><span>prime_meridian_name :</span></dt><dd>Greenwich</dd><dt><span>geographic_crs_name :</span></dt><dd>Unknown datum based upon the WGS 84 ellipsoid</dd><dt><span>horizontal_datum_name :</span></dt><dd>Not_specified_based_on_WGS_84_spheroid</dd><dt><span>projected_crs_name :</span></dt><dd>UTM Zone 13, Northern Hemisphere</dd><dt><span>grid_mapping_name :</span></dt><dd>transverse_mercator</dd><dt><span>latitude_of_projection_origin :</span></dt><dd>0.0</dd><dt><span>longitude_of_central_meridian :</span></dt><dd>-105.0</dd><dt><span>false_easting :</span></dt><dd>500000.0</dd><dt><span>false_northing :</span></dt><dd>0.0</dd><dt><span>scale_factor_at_central_meridian :</span></dt><dd>0.9996</dd><dt><span>spatial_ref :</span></dt><dd>PROJCS[&quot;UTM Zone 13, Northern Hemisphere&quot;,GEOGCS[&quot;Unknown datum based upon the WGS 84 ellipsoid&quot;,DATUM[&quot;Not_specified_based_on_WGS_84_spheroid&quot;,SPHEROID[&quot;WGS 84&quot;,6378137,298.257223563,AUTHORITY[&quot;EPSG&quot;,&quot;7030&quot;]]],PRIMEM[&quot;Greenwich&quot;,0],UNIT[&quot;degree&quot;,0.0174532925199433,AUTHORITY[&quot;EPSG&quot;,&quot;9122&quot;]]],PROJECTION[&quot;Transverse_Mercator&quot;],PARAMETER[&quot;latitude_of_origin&quot;,0],PARAMETER[&quot;central_meridian&quot;,-105],PARAMETER[&quot;scale_factor&quot;,0.9996],PARAMETER[&quot;false_easting&quot;,500000],PARAMETER[&quot;false_northing&quot;,0],UNIT[&quot;metre&quot;,1,AUTHORITY[&quot;EPSG&quot;,&quot;9001&quot;]],AXIS[&quot;Easting&quot;,EAST],AXIS[&quot;Northing&quot;,NORTH]]</dd><dt><span>GeoTransform :</span></dt><dd>779580.0 30.0 0.0 4551060.0 0.0 -30.0</dd></dl></div><div class='xr-var-data'><pre>array(0)</pre></div></li></ul></div></li><li class='xr-section-item'><input id='section-b8e0d9b7-7322-4ca7-81d1-ec3a803dafbc' class='xr-section-summary-in' type='checkbox'  checked><label for='section-b8e0d9b7-7322-4ca7-81d1-ec3a803dafbc' class='xr-section-summary' >Attributes: <span>(4)</span></label><div class='xr-section-inline-details'></div><div class='xr-section-details'><dl class='xr-attrs'><dt><span>scale_factor :</span></dt><dd>0.0001</dd><dt><span>add_offset :</span></dt><dd>0.0</dd><dt><span>grid_mapping :</span></dt><dd>spatial_ref</dd><dt><span>_FillValue :</span></dt><dd>-9999</dd></dl></div></li></ul></div></div>




```python
rio_env.__exit__()
```


```python

```
