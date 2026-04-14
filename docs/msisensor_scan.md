MSIsensor2 is the default microsatellite instability detection tool used in the pipeline.
MSIsensor-pro is available for [MSIsensor-pro licensed users](https://github.com/xjtu-omics/msisensor-pro/blob/master/LICENSE).

> [!IMPORTANT]
> `--msisensor_scan` is interpreted differently depending on the selected MSI tool:
>
> - **MSIsensor2 mode (default):** provide a scan list (`msisensor2 scan` output).
> - **MSIsensor-pro mode (`--use_msisensor_pro_licensed`):** provide a baseline file for `msisensor-pro pro` (not raw `msisensor-pro scan` output).

# Steps to Generate a MSIsensor2 Scan List

1. [Install MSIsensor2](https://github.com/niu-lab/msisensor2?tab=readme-ov-file#install)

2. Download and **_unzip_** the reference genome from GIAB, [fasta.gz link](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz).

> [!WARNING]
> If the genome is not unzipped, msisensor2 will hang indefinitely.

3. Run the MSIsensor2 scan command:

```console
msisensor2 scan \
        -d GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta \
        -o GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.msisensor2_scan.list
```

## Selecting an MSIsensor2 Model

MSIsensor2 relies on machine learning models to improve MSI detection.
While MSIsensor2 performs well in comparisons, information on the models or samples used to generate them is lacking, [Anthony & Seoighe 2024](https://pmc.ncbi.nlm.nih.gov/articles/PMC11317526/).

Models are available from the [msisensor2 github](https://github.com/niu-lab/msisensor2) for three human genome builds b37, hg19, and hg38.

You can select a models for a specific genome using the `--msisensor2_model_name` parameter.
The default is `hg38`.

# Steps to Generate a MSIsensor-pro Baseline File

> [!IMPORTANT]
> [MSIsensor-pro requires a license for commercial use.](https://github.com/xjtu-omics/msisensor-pro/blob/master/LICENSE)

1. [Install MSIsensor-pro](https://github.com/xjtu-omics/msisensor-pro/blob/master/docs/3_Installation.md)

2. Download and **_unzip_** the reference genome from GIAB, [fasta.gz link](https://ftp-trace.ncbi.nlm.nih.gov/ReferenceSamples/giab/release/references/GRCh38/GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta.gz).

> [!WARNING]
> If the genome is not unzipped, msisensor-pro will hang indefinitely.

3. Run the MSIsensor-pro scan command:

```console
msisensor-pro scan \
        -d GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.fasta \
        -o GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.msisensorpro_scan.list
```

4. Run `msisensor-pro pro` on a cohort of normal samples using the scan file above as `-d` and collect each sample's `*_all` output.

5. Build the baseline:

```console
msisensor-pro baseline \
        -d GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.msisensorpro_scan.list \
        -i normal_samples_pro_all.txt \
        -o GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.msisensorpro_baseline.list
```

6. Use the resulting baseline file with this pipeline:

```console
--use_msisensor_pro_licensed \
--msisensor_scan GRCh38_GIABv3_no_alt_analysis_set_maskedGRC_decoys_MAP2K3_KMT2C_KCNJ18.msisensorpro_baseline.list
```
