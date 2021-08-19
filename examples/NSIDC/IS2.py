import pandas as pd
import datetime as dt

def getATL03(f, beam):
    """
    taken from https://github.com/ICESAT-2HackWeek/overcast/blob/master/overcast/readers.py
    """
    # height of each received photon, relative to the WGS-84 ellipsoid (with some, not all corrections applied, see background info above)
    heights=f[beam]['heights']['h_ph'][:]
    # latitude (decimal degrees) of each received photon
    lats=f[beam]['heights']['lat_ph'][:]
    # longitude (decimal degrees) of each received photon
    lons=f[beam]['heights']['lon_ph'][:]
    # seconds from ATLAS Standard Data Product Epoch. use the epoch parameter to convert to gps time
    dt=f[beam]['heights']['delta_time'][:]
    # confidence level associated with each photon event
    # -2: TEP
    # -1: Events not associated with a specific surface type
    #  0: noise
    #  1: buffer but algorithm classifies as background
    #  2: low
    #  3: medium
    #  4: high
    # Surface types for signal classification confidence
    # 0=Land; 1=Ocean; 2=SeaIce; 3=LandIce; 4=InlandWater    
    conf=f[beam]['heights']['signal_conf_ph'][:,2] #choose column 2 for confidence of sea ice photons
    # number of ATL03 20m segments
    n_seg, = f[beam]['geolocation']['segment_id'].shape
    # first photon in the segment (convert to 0-based indexing)
    Segment_Index_begin = f[beam]['geolocation']['ph_index_beg'][:] - 1
    # number of photon events in the segment
    Segment_PE_count = f[beam]['geolocation']['segment_ph_cnt'][:]
    # along-track distance for each ATL03 segment
    Segment_Distance = f[beam]['geolocation']['segment_dist_x'][:]
    # along-track distance (x) for photon events
    x_atc = np.copy(f[beam]['heights']['dist_ph_along'][:])
    # cross-track distance (y) for photon events
    y_atc = np.copy(f[beam]['heights']['dist_ph_across'][:])

    for j in range(n_seg):
        # index for 20m segment j
        idx = Segment_Index_begin[j]
        # number of photons in 20m segment
        cnt = Segment_PE_count[j]
        # add segment distance to along-track coordinates
        x_atc[idx:idx+cnt] += Segment_Distance[j]
    df03=pd.DataFrame({'lats':lats,'lons':lons,'x':x_atc,'y':y_atc,'heights':heights,'dt':dt,'conf':conf})
    return df03