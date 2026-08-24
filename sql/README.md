# Data

This folder contains the data outputs used in the Dunnhumby Customer & Promotional Opportunity Analysis.

## Source Dataset

The project uses **dunnhumby - The Complete Journey**, a retail customer analytics dataset containing household-level transactions, customer attributes, direct marketing campaign history, coupons, and promotional information.

The original dataset covers approximately two years of purchasing activity across 2,500 households.

### Original Source

The dataset is provided by dunnhumby:

[The Complete Journey - dunnhumby Source Files](https://www.dunnhumby.com/source-files/)

### Download

The dataset can also be downloaded from Kaggle:

[Dunnhumby - The Complete Journey - Kaggle](https://www.kaggle.com/datasets/frtgnn/dunnhumby-the-complete-journey)

After downloading and extracting the dataset, place the raw CSV files locally under:

```text
data/
└── raw/
    ├── campaign_desc.csv
    ├── campaign_table.csv
    ├── causal_data.csv
    ├── coupon.csv
    ├── coupon_redempt.csv
    ├── hh_demographic.csv
    ├── product.csv
    └── transaction_data.csv
