# Promotional Investment Recommendation Memo

**Project:** Customer & Promotional Opportunity Analysis - dunnhumby Complete Journey Dataset
**Scope:** 2,500 households, 2.6M transactions, 102 weeks, $8.06M total sales

---

## Problem

Leadership needs to know where to focus promotional investment: which product
categories and customer segments deserve more attention, and where current
promotional strategy could be better targeted. Without breaking performance apart
by category and household segment, it's not possible to tell whether spend is
going to the households and categories that will actually respond to it.

## Method

Household-level behavioral data (purchases, category engagement, campaign
history) was combined into a promotional opportunity score built from three
weighted components: engagement (35%), category affinity (30%), and campaign
responsiveness (35%). The scoring logic was built in Python, translated into SQL,
and validated a third time via AWS Athena - all three layers agree on every core
figure to the cent. A campaign-response comparison, stratified by household value
tier to control for baseline spending differences, tested whether campaign
exposure is associated with higher spending. One campaign scenario was modeled
for the highest-opportunity untapped households.

## Findings

**Category performance is concentrated.** GROCERY drives 50.81% of total sales;
the top 4 categories account for the large majority of revenue. Category reach
and category value are not the same thing - some categories generate high sales
from relatively few households, while others drive broad customer penetration at
lower per-category value. These require different promotional approaches.

**Household value is concentrated in one segment.** High Value – Frequent
households are 42.0% of the base but generate 76.36% of total sales ($6.15M).
Low Value households are 41.8% of the base but only 11.61% of sales.

**A specific, high-value untapped household group exists.** Ten households -
led by 1023, 2459, and 707 - combine near-ceiling engagement (avg. 99.17th
percentile) and category affinity (avg. 98.97th percentile) with **zero**
recorded campaign history (0.00th percentile). This is the single most
actionable finding in the analysis: a small, identifiable group with strong
purchasing behavior that promotional activity has never reached.

**Campaign exposure is associated with higher spending, within value tier -
but not universally.** Comparing exposed vs. non-exposed households within the
same value tier (controlling for baseline spending differences), exposed
households showed meaningfully higher spend in most tiers. However, the tier
containing the ten untapped households did **not** show a positive gap in the
historical data, so no campaign effect for this specific group can be assumed
from past results.

## Recommendation

**Target the ten identified households directly.** They are already
identifiable in the existing customer base at zero acquisition cost, and
represent the clearest, most defensible promotional opportunity in the data.
Under an illustrative +10% sensitivity case, this represents approximately
**$18.11K in potential incremental sales** on a $181.06K baseline - treated as
a sensitivity case, not a forecast, since the households' own value tier showed
no historical evidence of positive campaign lift. Prioritize households 1023,
2459, and 707 first, as they carry the largest potential incremental value.

**Beyond this group, promotional investment should remain segmented rather than
uniform**: retention-focused for High Value – Frequent, frequency-building for
High Value – Less Frequent, and selective/low-cost for Low Value households,
where broad discounting has the weakest expected return.

## Assumptions & Limitations

- The +10% uplift is an **illustrative sensitivity case**, not a causal or
  evidence-based estimate - the untapped households' own value tier showed no
  positive campaign-exposure gap historically.
- The exposed-vs-non-exposed comparison is a stratified **observational**
  comparison, not a randomized experiment; some of the observed gap may reflect
  pre-existing engagement differences rather than campaign effect.
- Demographic data (age, income, homeownership) covers only 32% of households
  and was treated as supplementary context, not primary segmentation.
- The dataset's `quantity` field mixes item counts and weight-based units
  depending on product type; category-level quantity comparisons should be
  read directionally, not as literal unit counts.
- Actual campaign response for the ten untapped households is unknown and
  would need to be validated through a real campaign with proper measurement
  before scaling any assumption drawn from this analysis.
