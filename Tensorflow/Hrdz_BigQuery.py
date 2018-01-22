from google.cloud import bigquery
from google.cloud.bigquery import Dataset
from google.cloud.bigquery import job
import matplotlib.pyplot as plt
import numpy as np

client = bigquery.Client.from_service_account_json(json_credentials_path='mx-herdez-analytics-cf83fcf5fcc3.json')
# Perform a query.
QUERY = \
("""
SELECT 
  FechaPropuestaPago, desc_rubro_prop, no_doc_sap_zimp_fact, no_docto_prop, importe_propuesta, importe_PagadoDet, origen_zimp_fact, origen_mov_prop
, desc_estatus_prop, FormaPagoProp, forma_pago_zexp_fact, divisa_zimp_fact, divisa_original_prop, estatus
FROM `stg.result_z` 
where importe_propuesta<>0
order  by importe_propuesta
Limit 1000
""")

# query_job = client.run_sync_query(QUERY)
query_job = client.query(QUERY)
# query_job.use_legacy_sql = False  # Se ocupa es SQL Standard
rows = query_job.result()
# rows = query_job.rows
for row in rows:
    print(row)

from pkg_resources import get_distribution
__version__ = get_distribution('google-cloud-bigquery').version

print(__version__)







