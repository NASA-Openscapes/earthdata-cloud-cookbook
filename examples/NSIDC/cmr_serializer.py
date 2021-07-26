from IPython.display import display
from IPython.core.display import HTML


class QueryGranule(object):

    def _filter_related_links(self, filter: str):
        """
        Filter RelatedUrls from the UMM fields on CMR
        """
        matched_links = []
        for link in self._data['umm']['RelatedUrls']:
            if link['Type'] == filter:
                matched_links.append(link['URL'])
        return matched_links

    def __repr__(self):
        data_links = [l for l in self.data_links()]
        rep_str = f"""
        Id: {self.id()}
        Collection: {self._data['umm']['CollectionReference']}
        Spatial coverage: {self._data['umm']['SpatialExtent']}
        Temporal coverage: {self._data['umm']['TemporalExtent']}
        Size(MB): {self.size()}
        Data: {data_links}\n
        """
        return rep_str

    def _repr_html_(self):
        dataviz_img = ''.join([f'<img src="{l}" width="340px" />' for l in self.dataviz_links()[0:2]])
        data_links = ''.join([f'<a href="{l}" target="_blank">{l}</a><BR>' for l in self.data_links()])
        granule_str = f"""
        <p>
          <b>Id</b>: {self.id()}<BR>
          <b>Collection</b>: {self._data['umm']['CollectionReference']}<BR>
          <b>Spatial coverage</b>: {self._data['umm']['SpatialExtent']}<BR>
          <b>Temporal coverage</b>: {self._data['umm']['TemporalExtent']}<BR>
          <b>Size(MB):</b> {self.size()} <BR>
          <b>Data</b>: {data_links}<BR>
          <span>{dataviz_img}</span>
        </p>
        """
        return granule_str

    def __init__(self, cmr_granule):
        self._data = cmr_granule

    def id(self):
        return self._data['umm']['DataGranule']['Identifiers'][0]['Identifier']

    def size(self):
        total_size = sum([float(s['Size']) for s in self._data['umm']['DataGranule']['ArchiveAndDistributionInformation']])
        return total_size

    def data_links(self):
        links = self._filter_related_links('GET DATA')
        return links

    def dataviz_links(self):
        links = self._filter_related_links('GET RELATED VISUALIZATION')
        return links


class QueryResult(object):

    def __init__(self, granules):
        self.granules = [QueryGranule(g) for g in granules]

    def items(self):
        return self.granules

    def apply(self, some_operation):
        """
        If the data type is supported by xarray or rioxarray we can do some cool things
        this would be possible if the format is NetCDF/HDF5 or a raster.
        """
        return None

    def reproject(self, target_src: str):
        """
        use pyproj or the internal xarray/rioxarray methods to reproject
        """
        return None

    def crop(self, geometry: Any):
        """
        Spatial crop of each of the granules using a geojson geometry
        """
        return None

    def filter(self, some_filter):
        """
        Filter granules based on variable criteria  i.e. q_flag>10
        """
        return None
