# PrimeRx Flow — Alert-to-Treatment & Commercial Opportunity Analysis
## Complete Interview Preparation Guide for ProcDNA Case Study Round

---

> **Prepared by**: Group 3 — ProcDNA Business Analyst Hiring Process
>> **Members**: Kaushal Raj , Pradeep Modak , Ashwini Kumar
>>> **Case Study Date**: June 20, 2026   
> **Company**: ProcDNA (pharma data analytics consulting)  
> **Product Under Analysis**: Nexavir (Drug ID: DRG001) by PrimeRx  
> **Data Period**: ~18 months (July 2023 – December 2024)

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Pharma Domain Knowledge](#2-pharma-domain-knowledge)
3. [Dataset Understanding](#3-dataset-understanding)
4. [Question-by-Question Full Explanation](#4-question-by-question-full-explanation)
5. [Connecting the Dots — Overall Story](#5-connecting-the-dots--overall-story)
6. [Executive Summary Talking Points](#6-executive-summary-talking-points)
7. [Technical Approach](#7-technical-approach)
8. [Likely Interview Questions — Full List](#8-likely-interview-questions--full-list)
9. [Things to Watch Out For in the Interview](#9-things-to-watch-out-for-in-the-interview)
10. [Quick Reference Cheat Sheet](#10-quick-reference-cheat-sheet)

---

## 1. Project Overview

### 1.1 What is ProcDNA?

ProcDNA is a **data analytics consulting firm** that specializes in the **pharmaceutical and life sciences industry**. They help pharma companies turn raw commercial data — prescriptions, clinical alerts, doctor activity, hospital affiliations — into actionable business insights. Their clients are pharma companies that need to optimize their sales strategy, identify missed commercial opportunities, and maximize the return on their field force (sales representatives). As a Business Analyst at ProcDNA, my job is to sit at the intersection of data, healthcare, and business strategy. We are not just running queries — we are telling a business story with data.

### 1.2 What is Pharma Commercial Analytics?

Pharma commercial analytics is a specialized branch of business analytics focused on the **commercial (sales and marketing) side of pharmaceutical companies**. Unlike clinical analytics (which deals with drug trials and patient outcomes), commercial analytics focuses on questions like:

- Which doctors are prescribing our drug vs. competitors?
- Which hospitals represent untapped sales opportunities?
- Are our clinical alerts actually changing doctor behavior?
- How should we deploy our limited sales force for maximum ROI?

The pharma industry is unique because the "customer" is not the end consumer (the patient) — it's the **doctor (HCP)** who writes the prescription. So all commercial analytics revolves around understanding, segmenting, and influencing doctor behavior.

### 1.3 Our Specific Task

PrimeRx is a pharmaceutical company whose flagship product is **Nexavir (DRG001)**, a treatment for a condition with high clinical need. PrimeRx has an **alert system** that generates clinical signals when a patient's lab test indicates they may need treatment. These alerts go to the patient's doctor (HCP). The business question is: **are these alerts actually leading to prescriptions?**

We were given 18 months of data across three datasets (Alerts, Sales, Affiliation) and asked to:
1. Identify which doctors are most active and whether they help our product
2. Find doctors who receive clinical signals but don't prescribe
3. Quantify how much business is going to competitors
4. Identify hospitals sitting on untapped opportunities
5. Measure whether the alert program actually changes prescribing behavior
6. Recommend how to allocate the sales force for maximum commercial impact

### 1.4 Why This Problem Matters in the Real Pharma Industry

This is not an academic exercise — this is a **real-world pharma analytics problem** that companies spend millions of dollars trying to solve. Every pharma company faces the "last mile" problem: a patient needs a drug, the clinical evidence supports it, but the doctor doesn't prescribe it. The reasons can be:

- The doctor is unaware of the drug
- The doctor prefers a competitor product due to habit or sales rep influence
- The hospital doesn't have the drug on formulary
- The doctor received the alert but didn't act on it

By connecting alert data to prescription data, we can identify **exactly where the leakage is happening** — at the doctor level, the account level, and the behavioral level. This allows the sales team to focus their limited resources on the highest-value opportunities instead of spreading thin across all doctors.

---

## 2. Pharma Domain Knowledge

### 2.1 HCP (Healthcare Provider)

An HCP is any licensed medical professional who can write prescriptions — typically a **doctor, physician, or specialist**. In pharma commercial analytics, HCPs are the primary unit of analysis because they are the decision-makers. When we say "HCP041 has 200 alerts," we mean that doctor #041 has received 200 clinical signals about patients who may need treatment. Each HCP has a unique identifier (like HCP041) that lets us track their behavior across alerts, prescriptions, and hospital affiliations. In our dataset, there are **220 unique HCPs** in the Alerts data and **177 unique HCPs** in the Sales data — meaning some doctors who receive alerts never prescribe anything at all.

### 2.2 Clinical Alert / Lab Result

A **clinical alert** is an automated notification generated when a patient's laboratory test result indicates a potential need for treatment. In our dataset, each alert has a `Lab_Result` field that is either **Positive** or **Negative**:

- **Positive**: The patient's lab test result indicates they likely **need treatment** — this is the strongest commercial signal. A positive alert essentially says "this patient is clinically eligible for Nexavir."
- **Negative**: The lab test did not indicate immediate treatment need — less commercially relevant, but still shows the doctor is running the right diagnostic tests.

The business significance of a positive alert is enormous: it means there is a **patient in front of a doctor who needs our drug**. If that doctor doesn't prescribe Nexavir after receiving a positive alert, that's a missed commercial opportunity.

### 2.3 Prescription Volume

**Prescription Volume** is the total number of units (tablets, doses, vials, etc.) prescribed — it is NOT the number of prescriptions written. For example, if a doctor writes 3 prescriptions of 10 tablets each, the prescription count is 3, but the prescription volume is 30. We use volume because it better reflects the **commercial value** — a doctor who writes one prescription for 100 units is more valuable than a doctor who writes 10 prescriptions for 1 unit each. In our Sales dataset, the `Prescription_Volume` column represents the total units prescribed in each transaction.

### 2.4 DRG001 vs. Competitor Drugs — Market Share

In our dataset, there are **4 drugs**:

| Drug ID | Drug Name | Role |
|---------|-----------|------|
| **DRG001** | **Nexavir** | **Our drug** — this is PrimeRx's product |
| DRG002 | Rivalex | Competitor #1 — **top competitive threat** |
| DRG003 | Omniphar | Competitor #2 |
| DRG004 | Celudrin | Competitor #3 |

**Market share** in pharma means the percentage of total prescriptions that go to our drug vs. competitors. If a doctor writes 100 total units and 60 go to Nexavir, our market share with that doctor is 60%. The goal is to increase DRG001's share at every doctor and every account.

### 2.5 Account (Hospital / Clinic / Health System)

In pharma, an **"account"** refers to a healthcare facility — a **hospital, clinic, medical center, or health system** — where multiple doctors work. Accounts are important because pharma companies often have **account-level strategies**: they negotiate formulary placement (getting the drug approved for use in that hospital), run institutional selling programs, and assign key account managers. In our Affiliation dataset, there are **23 unique accounts** (e.g., ACC001 = Northside General Hospital, ACC003 = Riverside Health System). Understanding which accounts have high clinical activity but low prescription conversion allows the sales team to prioritize institutional interventions.

### 2.6 Affiliation — Doctor-to-Hospital Mapping

The **Affiliation dataset** maps which doctor (HCP) works at which hospital (Account). This is critical because:

- A single hospital might have 24 doctors affiliated with it (like ACC003, Riverside Health System)
- Some of those doctors may be actively prescribing Nexavir, while others are not
- The sales team needs to know which hospitals have the most "untapped" doctors — those who could prescribe but don't

Without the affiliation mapping, we would only see doctor-level data. With it, we can **roll up doctor behavior to the account level** and identify which hospitals need account-level interventions vs. individual doctor visits.

### 2.7 Sales Rep / Field Force

Pharma companies deploy **sales representatives** (also called "reps" or "field force") to visit doctors and promote their drug. A rep's job is to:
- Meet with doctors face-to-face (called a "detail" or "call")
- Educate them about the drug's clinical benefits
- Provide samples and leave-behind materials
- Build relationships that influence prescribing behavior

In our case study, PrimeRx has **40 sales reps**, each making **8 calls per day** across **20 field days per month**. This gives a total monthly capacity of **6,400 calls** and **19,200 calls per quarter**. The key strategic question is: how should these 19,200 calls be allocated across different types of doctors?

### 2.8 Conversion Ratio

The **conversion ratio** measures how efficiently alerts are being converted into prescriptions. We define it as:

$$\text{Conversion Ratio} = \frac{\text{DRG001 Prescription Count}}{\text{Total Alert Count}}$$

A low conversion ratio means the account is generating many alerts (lots of patients who need treatment) but few prescriptions for our drug — this is an **untapped opportunity**. For example, ACC001 (Northside General) has a conversion ratio of only 3.73 — meaning for every 100 alerts, only about 3-4 prescriptions are written for Nexavir. This is extremely low and represents the biggest single opportunity in our dataset.

### 2.9 Lift — Behavioral Change Measurement

**Lift** measures whether a specific event (in our case, the first positive alert) changed a doctor's prescribing behavior. We calculate it by comparing prescription volume in a **90-day window before** the event vs. a **90-day window after**:

- A **positive lift** means the doctor prescribed MORE after the alert — the alert worked!
- A **negative lift** means the doctor prescribed LESS — the alert didn't change behavior
- If **Pre = 0 and Post > 0**, the doctor is a "New Starter" — they went from zero prescribing to active prescribing after the alert

Lift is the single most important metric for proving that the alert program has commercial value.

### 2.10 HCP Segmentation

**Segmentation** is the process of dividing doctors into behavioral groups so that the sales team can treat each group differently. In our analysis (Q6), we created three segments:

| Segment | Definition | Count | What It Means |
|---------|-----------|-------|--------------|
| **New Starters** | Pre=0, Post>0 | 64 HCPs | Were not prescribing before the alert, started after — strongest signal of alert-driven conversion |
| **Growers** | Pre>0, Lift ≥ +20% | 25 HCPs | Were already prescribing and significantly increased after the alert — alert amplified existing behavior |
| **Non-responders** | Everything else | 125 HCPs | Either showed no improvement or declined — alert did not change their behavior |

Segmentation is a **core pharma analytics task** because it allows the sales team to tailor their approach: invest heavily in New Starters and Growers (where the ROI is highest), and deprioritize Non-responders (where calls have minimal impact).

---

## 3. Dataset Understanding

### 3.1 The Three Datasets

#### Alerts Dataset (9,537 rows)

| Column | Type | Description |
|--------|------|------------|
| Alert_ID | String | Unique identifier for each alert (e.g., ALT001134) |
| Alert_Date | Date | When the alert was generated (range: July 2023 – December 2024) |
| HCP_ID | String | Which doctor received the alert |
| Lab_Result | String | "Positive" (patient likely needs treatment) or "Negative" (no immediate need) |

This dataset tells us **which doctors are seeing patients who might need Nexavir**. Each row is one clinical alert event. A doctor with many alerts has a high volume of potentially eligible patients.

#### Sales Dataset (5,917 rows)

| Column | Type | Description |
|--------|------|------------|
| Prescription_ID | String | Unique identifier for each prescription (e.g., RX004327) |
| Prescription_Date | Date | When the prescription was written (range: same period) |
| HCP_ID | String | Which doctor wrote the prescription |
| Drug_Name | String | Human-readable drug name (Nexavir, Rivalex, Omniphar, Celudrin) |
| Drug_ID | String | Drug identifier (DRG001 = our drug, DRG002-DRG004 = competitors) |
| Prescription_Volume | Integer | Number of units prescribed in this transaction |

This dataset tells us **who is prescribing what and how much**. Note that it includes prescriptions for ALL drugs, not just Nexavir — this lets us calculate market share.

#### Affiliation Dataset (216 rows)

| Column | Type | Description |
|--------|------|------------|
| HCP_ID | String | Doctor identifier |
| Account_ID | String | Hospital/clinic identifier (e.g., ACC001) |
| Account_Name | String | Human-readable name (e.g., "Northside General Hospital") |

This dataset tells us **where each doctor works**. There are 216 HCPs mapped across 23 accounts. This is the bridge that lets us roll up doctor-level data to the hospital/account level.

### 3.2 How the Datasets Connect

All three datasets connect through the **HCP_ID** field:

```
Alerts.HCP_ID  ──┐
                  ├──  HCP_ID (common key)
Sales.HCP_ID   ──┤
                  │
Affiliation.HCP_ID ──┘
```

This means we can:
- **Alerts + Sales**: For any doctor, see how many alerts they received AND how many prescriptions they wrote → measures alert-to-prescription conversion
- **Alerts + Affiliation**: Roll up alert volume to the account/hospital level
- **Sales + Affiliation**: Roll up prescription activity to the account level
- **All three**: Full picture — which hospitals have high alerts, low prescriptions, and which specific doctors are responsible

### 3.3 Key Data Quality Observations

1. **Not all alert HCPs appear in Sales**: There are 220 unique HCPs in Alerts but only 177 in Sales. This means **43 doctors received clinical alerts but never wrote a single prescription** for any drug — a major finding in itself.

2. **Date formats**: Alert_Date and Prescription_Date were stored as Excel serial numbers in the raw file. We converted them to proper datetime objects using `pd.to_datetime()` in pandas.

3. **HCP_ID normalization**: We applied `.str.strip().str.upper()` to all HCP_ID columns before merging to prevent mismatches due to whitespace or case differences.

4. **No null values**: All three datasets had zero null values across all columns — the data was clean in terms of completeness.

5. **Drug coverage**: The Sales dataset includes prescriptions for 4 drugs (DRG001–DRG004). We filter to DRG001 when calculating "our drug" metrics and treat DRG002–DRG004 as competitors.

---

## 4. Question-by-Question Full Explanation

---

### Q1: Who are the most active doctors and are they helping our product?

#### (a) What the question is asking

Find the top 10 doctors by total alert volume (who sees the most eligible patients?) and the top 10 by total prescription volume (who prescribes the most overall?). Then compare the two lists.

#### (b) Business problem it solves

The sales team needs to know: are our highest-signal doctors (most alerts = most patients who need treatment) also our highest-volume prescribers? If the two lists don't overlap, there's a disconnect — doctors are seeing patients but not prescribing proportionally.

#### (c) Step-by-step approach

1. **Filter universe**: Only include doctors who appear in the Alerts dataset (220 HCPs).
2. **Ranking 1 (Alert Volume)**: Group alerts by HCP_ID, count rows per HCP, sort descending, take top 10.
3. **Ranking 2 (Prescription Volume)**: From Sales, filter to only HCPs in the alerts universe, group by HCP_ID, sum Prescription_Volume, sort descending, take top 10.
4. **Compare**: Check overlap between the two lists.

#### (d) Key results

**Ranking 1 — Top 10 by Alert Volume:**

| Rank | HCP_ID | Total Alerts |
|------|--------|-------------|
| 1 | HCP041 | 200 |
| 2 | HCP011 | 196 |
| 3 | HCP035 | 194 |
| 4 | HCP029 | 187 |
| 5 | HCP021 | 186 |
| 6 | HCP044 | 180 |
| 7 | HCP042 | 174 |
| 8 | HCP036 | 171 |
| 9 | HCP027 | 165 |
| 10 | HCP010 | 163 |

**Ranking 2 — Top 10 by Prescription Volume:**

| Rank | HCP_ID | Total Rx Volume |
|------|--------|----------------|
| 1 | HCP185 | 2,900 |
| 2 | HCP019 | 2,736 |
| 3 | HCP192 | 2,710 |
| 4 | HCP187 | 2,680 |
| 5 | HCP188 | 2,650 |
| 6 | HCP183 | 2,620 |
| 7 | HCP189 | 2,590 |
| 8 | HCP186 | 2,560 |
| 9 | HCP184 | 2,530 |
| 10 | HCP190 | 2,500 |

#### (e) Business insight

**Only HCP019 appears in both top-10 lists.** This is a critical finding — it means the doctors who are seeing the most patients who need treatment (highest alerts) are NOT the same doctors who are prescribing the most. This disconnect is a major commercial opportunity: high-alert doctors have the patient volume to become high prescribers, but something is preventing that conversion.

#### (f) Assumptions

- We used ALL alerts (both Positive and Negative) for alert volume ranking because the question said "total number of alerts generated."
- We used total prescription volume across ALL drugs (not just DRG001) for Ranking 2 because the question said "prescription volume in the Sales data."

### Q2: Which doctors see the need but don't act on it?

#### (a) What the question is asking

Among doctors who received **positive** alerts (patient likely needs treatment), find those who had **zero prescription activity for ANY drug within 30 days** of their first positive alert. Rank the top 10 by positive alert count. Also build a funnel showing the drop-off from positive alerts → multiple positive alerts → zero Rx.

#### (b) Business problem it solves

This identifies the **biggest leakage in the commercial pipeline**. A positive alert is the strongest signal that a patient needs Nexavir. If a doctor receives that signal and doesn't prescribe anything within 30 days, that patient may go untreated or be treated elsewhere. These are the doctors where a single sales rep visit could unlock new prescriptions.

#### (c) Step-by-step approach

1. Filter alerts to only **Positive** lab results.
2. For each HCP, find the **earliest positive alert date** (first signal).
3. Check the Sales dataset: does this HCP have ANY prescription (any drug) within 30 days after that first positive alert?
4. Separate HCPs into "has Rx within 30d" and "no Rx within 30d."
5. Among those with zero Rx, rank by total positive alert count (descending).
6. Build the funnel: count HCPs at each stage.

#### (d) Key results

**Top 10 HCPs with positive alerts but zero Rx in 30 days:**

| Rank | HCP_ID | Positive Alert Count |
|------|--------|---------------------|
| 1 | HCP041 | 127 |
| 2 | HCP011 | 118 |
| 3 | HCP035 | 112 |
| 4 | HCP029 | 108 |
| 5 | HCP021 | 104 |
| 6 | HCP044 | 99 |
| 7 | HCP042 | 96 |
| 8 | HCP036 | 93 |
| 9 | HCP027 | 89 |
| 10 | HCP010 | 85 |

**Funnel:**

| Stage | HCP Count | Drop-off |
|-------|-----------|----------|
| HCPs with ≥1 positive alert | 214 | — |
| HCPs with multiple positive alerts | 198 | 7.5% drop |
| Multiple positive alerts + zero Rx (30d) | 68 | **65.7% drop** |

#### (e) Business insight

**68 doctors (32% of those with multiple positive alerts) received strong clinical signals but did absolutely nothing.** HCP041 alone received 127 positive alerts — 127 patients who likely needed treatment — and didn't write a single prescription for any drug within 30 days of the first one. These 68 HCPs represent the single largest immediate commercial opportunity. A targeted sales campaign to even half of them could generate significant new prescriptions.

#### (f) Assumptions

- We used a **30-day window** after the **first** positive alert as the evaluation period, as specified in the question.
- We checked for prescriptions of **any drug** (not just DRG001) — if the doctor prescribed a competitor within 30 days, they would NOT appear in the non-prescriber list.
- We defined "multiple positive alerts" as **more than 1** positive alert (strictly greater than 1).

### Q3: Among our top doctors, how much business is going to competitors?

#### (a) What the question is asking

For the Top 10 HCPs by alert volume (from Q1), calculate what percentage of their total prescription volume goes to our drug (DRG001) vs. competitor drugs. Also identify which specific competitor drug is stealing the most volume.

#### (b) Business problem it solves

This is a **market share analysis** at the doctor level. Even if a doctor is prescribing, they might be prescribing competitors instead of Nexavir. The sales team needs to know which high-value doctors are leaking business to competitors so they can launch targeted competitive detailing campaigns.

#### (c) Step-by-step approach

1. Take the top 10 HCPs by alert volume from Q1.
2. For each, pull ALL prescription records from Sales.
3. Split into DRG001 (our drug) and non-DRG001 (competitors).
4. Calculate percentage share for each.
5. Identify the top competitor drug by total volume across all 10 HCPs.

#### (d) Key results

| Rank | HCP_ID | Total Rx | Our Drug % | Competitor % |
|------|--------|----------|-----------|-------------|
| 1 | HCP041 | 0 | N/A | N/A |
| 2 | HCP011 | 0 | N/A | N/A |
| 3 | HCP035 | 992 | 0.0% | 100.0% |
| 4 | HCP029 | 1,995 | 61.2% | 38.8% |
| 5 | HCP021 | 0 | N/A | N/A |
| 6 | HCP044 | 296 | 0.0% | 100.0% |
| 7 | HCP042 | 0 | N/A | N/A |
| 8 | HCP036 | 1,895 | 64.7% | 35.3% |
| 9 | HCP027 | 981 | 63.0% | 37.0% |
| 10 | HCP010 | 740 | 74.7% | 25.3% |

**Top competitor**: Rivalex (DRG002) with 1,470 total prescription volume among these HCPs.

#### (e) Business insight

This reveals **three distinct types of high-alert HCPs**:
1. **Zero prescribers** (HCP041, HCP011, HCP021, HCP042): No sales data at all — complete pipeline leakage.
2. **Competitor-dominated** (HCP035, HCP044): Prescribing actively but 100% goes to competitors — competitive displacement problem.
3. **Nexavir-strong** (HCP029, HCP036, HCP027, HCP010): Already prescribing Nexavir with 61-75% share — defend and grow.

Rivalex (DRG002) is the primary competitive threat. The sales team should prepare competitive detailing materials specifically addressing Rivalex.

#### (f) Assumptions

- We used total prescription volume (all drugs) as the denominator.
- HCPs with zero sales data show "N/A" rather than "0%" because there's no denominator.
- We used the user-provided Q1 alert ranking (which may differ slightly from our computed ranking).

### Q4: Which hospitals are sitting on the biggest untapped opportunity?

#### (a) What the question is asking

Join Alerts with Affiliation to get alert counts at the account (hospital) level. Find the Top 10 accounts by alert count. For each, calculate DRG001 prescription count and conversion ratio (Rx count / alert count). Rank by lowest conversion ratio.

#### (b) Business problem it solves

Individual doctor targeting is important, but pharma companies also need **account-level strategies**. A hospital with thousands of alerts but few prescriptions represents a systemic opportunity — the problem might be formulary access, institutional resistance, or lack of a key account manager. Account-level interventions (formulary placement, institutional contracts, nurse education) can unlock prescriptions from multiple doctors at once.

#### (c) Step-by-step approach

1. Join Alerts with Affiliation on HCP_ID to assign each alert to an account.
2. Group by Account_ID, count total alerts.
3. Take top 10 by alert count.
4. For those 10 accounts, join Sales (DRG001 only) with Affiliation to get total DRG001 prescription volume per account.
5. Calculate Conversion Ratio = DRG001 Rx Count / Total Alert Count.
6. Sort by lowest conversion ratio.

#### (d) Key results

| Rank | Account_ID | Account Name | Alerts | DRG001 Rx | Conversion Ratio |
|------|------------|-------------|--------|-----------|-----------------|
| 1 | ACC001 | Northside General Hospital | 3,296 | 12,297 | 3.73 |
| 2 | ACC003 | Riverside Health System | 1,195 | 4,947 | 4.14 |
| 3 | ACC002 | Eastview Medical Center | 2,350 | 12,223 | 5.20 |
| 4 | ACC004 | Metro Regional Hospital | 530 | 5,402 | 10.19 |
| 5 | ACC005 | Lakewood Medical Center | 585 | 9,148 | 15.64 |
| 6 | ACC006 | Central University Hospital | 493 | 9,887 | 20.05 |
| 7 | ACC012 | Greenfield Medical Associates | 85 | 1,804 | 21.22 |
| 8 | ACC009 | Sunset Medical Group | 100 | 2,699 | 26.99 |
| 9 | ACC007 | Pinecrest Hospital | 114 | 7,072 | 62.04 |
| 10 | ACC010 | Valley Health Partners | 92 | 9,616 | 104.52 |

#### (e) Business insight

**ACC001 (Northside General Hospital) is the #1 untapped opportunity** with 3,296 alerts (highest in the system) but a conversion ratio of only 3.73. This means for roughly every 100 clinical signals, only about 3-4 result in a Nexavir prescription. Compare this to ACC010 (Valley Health Partners) where the conversion ratio is 104.52 — over 25x more efficient. Northside General likely has systemic barriers (formulary, physician awareness, institutional preference for competitors) that need account-level intervention.

#### (f) Assumptions

- Conversion ratio uses DRG001 prescription volume (not count) in the numerator and total alert count in the denominator.
- We included all alerts (positive and negative) in the denominator as specified.
- The ranking is by LOWEST conversion ratio (worst performers first).

### Q5: Which accounts represent the largest untapped prescription opportunity?

#### (a) What the question is asking

For each account, calculate: total affiliated doctors, number of active DRG001 prescribers, total DRG001 Rx volume, and **Rx volume per active doctor**. Rank by lowest Rx-per-active-doctor ratio. Also create a scatter plot.

#### (b) Business problem it solves

Q4 looked at alert-to-Rx conversion. Q5 looks at a different angle: **are the active doctors at each account prescribing enough?** An account might have many doctors prescribing, but if each doctor writes very little, the per-doctor productivity is low — suggesting room for growth through deeper engagement with existing prescribers.

#### (c) Step-by-step approach

1. Count total doctors per account (from Affiliation).
2. Filter Sales to DRG001 only, merge with Affiliation to get account-level data.
3. Count distinct active prescribers per account (doctors with at least one DRG001 prescription).
4. Sum total DRG001 Rx volume per account.
5. Calculate Rx per Active Doctor = Total DRG001 Rx / Active Prescribers.
6. Rank by lowest ratio.

#### (d) Key results

| Rank | Account | Doctors | Active | DRG001 Rx | Rx/Active Doctor |
|------|---------|---------|--------|-----------|-----------------|
| 1 | ACC017 | 3 | 1 | 59 | 59.00 |
| 2 | ACC015 | 8 | 7 | 1,347 | 192.43 |
| 3 | ACC012 | 10 | 7 | 1,804 | 257.71 |
| 4 | ACC009 | 11 | 10 | 2,699 | 269.90 |
| 5 | ACC003 | 24 | 15 | 4,947 | 329.80 |
| 6 | ACC018 | 4 | 3 | 1,095 | 365.00 |
| 7 | ACC004 | 17 | 13 | 5,402 | 415.54 |
| 8 | ACC008 | 7 | 6 | 3,049 | 508.17 |
| 9 | ACC014 | 6 | 6 | 3,126 | 521.00 |
| 10 | ACC023 | 1 | 1 | 573 | 573.00 |

#### (e) Business insight

**ACC003 (Riverside Health System) is the highest-impact target**: it has 24 doctors (one of the largest accounts) but only 15 are actively prescribing DRG001, and those 15 are writing only 329.80 units each on average. There are **9 inactive doctors** at Riverside who could be activated, plus the existing 15 could increase their volume. ACC017 (Maplewood Clinic) has the worst ratio (59) but it's a small clinic with only 3 doctors — less strategic impact.

#### (f) Assumptions

- "Active prescriber" = any doctor with at least one DRG001 prescription in the entire dataset period.
- We excluded accounts with zero active prescribers from the ratio calculation (can't divide by zero).
- The scatter plot shows Total Affiliated Doctors (x-axis) vs. Rx per Active Doctor (y-axis).

### Q6: Did alerts actually change doctor behavior — before vs. after?

#### (a) What the question is asking

For each HCP with a positive alert, define a 90-day window before and after their first positive alert. Calculate DRG001 Rx volume in each window. Calculate Lift %. Classify into 3 behavioral segments. Find Top 10 by lift. Summarize segments.

#### (b) Business problem it solves

This is the **ROI question for the entire alert program**. PrimeRx invested in building and maintaining this alert system. Does it actually work? Do alerts change prescribing behavior? If yes, how much? And for which types of doctors? This analysis provides evidence-based proof of the alert program's commercial value.

#### (c) Step-by-step approach

1. Find each HCP's first positive alert date.
2. Define Pre-window: 90 days BEFORE that date. Post-window: 90 days AFTER.
3. Sum DRG001 Rx volume in each window.
4. Calculate Lift % = (Post - Pre) / Pre × 100.
5. Handle special cases: Pre=0 and Post>0 → "New Starter" (infinite lift); Pre=0 and Post=0 → "Non-responder."
6. Classify: New Starters (pre=0, post>0), Growers (pre>0, lift ≥ +20%), Non-responders (everything else).
7. Rank Top 10 by highest Lift %.
8. Create segment summary table.

#### (d) Key results

**Part A — Top 10 by Lift %:**

| Rank | HCP_ID | Pre 90d | Post 90d | Lift % |
|------|--------|---------|----------|--------|
| 1 | HCP040 | 8 | 143 | 1,687.5% |
| 2 | HCP050 | 10 | 107 | 970.0% |
| 3 | HCP006 | 32 | 249 | 678.1% |
| 4 | HCP108 | 31 | 238 | 667.7% |
| 5 | HCP016 | 50 | 279 | 458.0% |
| 6 | HCP159 | 42 | 232 | 452.4% |
| 7 | HCP157 | 72 | 387 | 437.5% |
| 8 | HCP211 | 42 | 223 | 431.0% |
| 9 | HCP209 | 64 | 335 | 423.4% |
| 10 | HCP125 | 49 | 214 | 336.7% |

**Part B — Segment Summary:**

| Segment | HCP Count | Avg Pre Rx | Avg Post Rx | Total Pre | Total Post | Avg Lift |
|---------|-----------|-----------|------------|-----------|-----------|---------|
| New Starters | 64 | 0 | 147.14 | 0 | 9,417 | N/A (pre=0) |
| Growers | 25 | 77.44 | 210.20 | 1,936 | 5,255 | +322.8% |
| Non-responders | 125 | 65.04 | 28.06 | 8,130 | 3,507 | -25.1% |

**Strongest commercial impact**: New Starters (64 HCPs went from 0 to 9,417 total Rx units).

#### (e) Business insight

The alert program **demonstrably works** for a segment of doctors:
- **64 New Starters** went from zero to prescribing — the alert directly catalyzed behavior change, generating 9,417 units of new revenue.
- **25 Growers** increased their prescribing by an average of +323% — the alert amplified existing behavior.
- However, **125 Non-responders (58%)** actually declined by 25% on average — for the majority of doctors, the alert alone isn't enough.

This proves the alert system has value, but it needs to be paired with sales rep follow-up to maximize impact. The alert triggers the signal; the rep closes the deal.

#### (f) Assumptions

- We used a **strict 90-day window** before and after the first positive alert date.
- Pre-window: [first_positive_date - 90 days, first_positive_date). Post-window: (first_positive_date, first_positive_date + 90 days].
- Only DRG001 prescriptions were counted (since we're measuring lift for OUR drug).
- New Starters have undefined Lift % (division by zero) — we report them separately rather than assigning infinity.

### Q7: Commercial HCP Prioritization — Field Force Allocation

#### (a) What the question is asking

Given 40 sales reps with 8 calls/day × 20 days/month = 6,400 calls/month (19,200/quarter), recommend how to allocate calls across the three segments from Q6.

#### (b) Business problem it solves

This is the **strategic resource allocation question** — the culmination of the entire analysis. Every pharma company has limited field force capacity. The question is: where should we deploy reps for maximum commercial ROI? This directly impacts quarterly revenue targets.

#### (c) Step-by-step approach

1. Calculate total capacity: 40 × 8 × 20 × 3 = 19,200 quarterly calls.
2. Assess each segment's value: New Starters (proven conversion), Growers (proven growth), Non-responders (low expected ROI).
3. Allocate proportionally based on expected ROI per call, not segment size.
4. Calculate implied rep allocation (% of 40 reps).

#### (d) Key results

| Segment | HCPs | % of Calls | Quarterly Calls | Reps |
|---------|------|-----------|----------------|------|
| New Starters | 64 | 50% | 9,600 | ~20 |
| Growers | 25 | 35% | 6,720 | ~14 |
| Non-responders | 125 | 15% | 2,880 | ~6 |
| **Total** | **214** | **100%** | **19,200** | **40** |

#### (e) Business insight

We recommend **50% of call capacity to New Starters** even though they're only 30% of HCPs because:
- They've already shown behavioral change (highest conversion probability)
- They need nurturing to prevent lapse back to zero
- Each call to a New Starter has the highest expected revenue per visit

**35% to Growers** because they're already expanding and need reinforcement to:
- Prevent competitor switching (protect the gains)
- Accelerate their growth trajectory

**Only 15% to Non-responders** because the data shows alerts alone don't change their behavior. However, we don't ignore them entirely because:
- A small subset may respond to in-person detailing even if they didn't respond to alerts
- Some may have addressable barriers (formulary, education)

#### (f) Assumptions

- Each call is equally effective (in reality, first calls have more impact than follow-ups).
- All 40 reps are equally productive.
- No geographic constraints (in reality, rep territories limit which doctors they can visit).
- The 3-month quarter follows immediately from the analysis period.

## 5. Connecting the Dots — Overall Story

This case study tells a **single coherent commercial story** from diagnosis to strategy:

**Act 1 — Identify the landscape (Q1):** We started by mapping the doctor universe. The top alert generators (HCP041: 200 alerts) are NOT the same as the top prescribers (HCP185: 2,900 Rx). Only HCP019 bridges both lists. This immediately tells us: the doctors who see the most eligible patients are not converting that clinical volume into prescription volume.

**Act 2 — Find the pipeline leak (Q2):** We zoomed into why. Of 214 doctors receiving positive alerts, 68 (32%) did absolutely nothing within 30 days. These aren't low-activity doctors — HCP041 alone received 127 positive alerts and wrote zero prescriptions. The funnel shows massive drop-off: 214 → 198 → 68 non-responders. This is where revenue is dying.

**Act 3 — Expose the competitive threat (Q3):** For doctors who ARE prescribing, we checked how much goes to competitors. HCP035 sends 100% to competitors. Rivalex (DRG002) is the #1 threat at 1,470 units. Even our own strongholds like HCP036 show 35% competitor share. The enemy is not inaction alone — it's also competitive displacement.

**Act 4 — Zoom out to the hospital level (Q4, Q5):** Individual doctors don't operate in isolation — they work in hospitals. ACC001 (Northside General) generates 3,296 alerts but converts at only 3.73 — the worst conversion in the system. ACC003 (Riverside) has 24 doctors but only 15 prescribe, with a low 329.80 Rx per active doctor. These are systemic, institutional problems that need account-level solutions (formulary changes, key account management, institutional selling).

**Act 5 — Prove the program works (Q6):** Before recommending more investment, we needed to prove the alert program actually changes behavior. It does: 64 New Starters went from zero to prescribing (9,417 total new units), and 25 Growers increased by an average of +323%. HCP040 saw a 1,687.5% lift. But 125 Non-responders declined — the alert alone isn't enough for everyone.

**Act 6 — Build the strategy (Q7):** Armed with these insights, we designed a field force allocation: 50% of 19,200 quarterly calls to New Starters (nurture the converts), 35% to Growers (accelerate the winners), 15% to Non-responders (selective investigation). This data-driven allocation maximizes ROI per sales dollar.

**The punchline:** The data tells us exactly where the commercial leakage is (68 non-prescribing HCPs, ACC001, Rivalex), proves that the alert program can fix it (64 New Starters), and shows us how to deploy our field force to capture the opportunity (50/35/15 allocation). It's not a data dump — it's a commercial action plan.

---

## 6. Executive Summary Talking Points

### 6.1 Five Most Important Findings

1. **68 HCPs are completely non-responsive**: They received multiple positive alerts indicating patients need treatment but wrote zero prescriptions within 30 days. This represents the single largest untapped opportunity — patients who need our drug and aren't getting it.

2. **Rivalex (DRG002) is the primary competitive threat**: Among our highest-alert doctors, Rivalex captures the largest competitor share at 1,470 units. Two HCPs (HCP035, HCP044) send 100% of their volume to competitors.

3. **ACC001 (Northside General Hospital) is the #1 account opportunity**: It generates 3,296 alerts (most in the system) but has a conversion ratio of only 3.73 — the lowest among top accounts.

4. **The alert program works — when followed up**: 64 New Starters went from zero to active prescribing post-alert (9,417 new units). HCP040 showed a 1,687.5% lift. Alerts change behavior, but they need sales rep follow-up to maximize impact.

5. **58% of doctors don't respond to alerts alone**: 125 Non-responders actually declined by 25% on average. This proves that alerts are necessary but not sufficient — the field force is essential.

### 6.2 Three Most Important Recommendations

1. **Launch an immediate targeted campaign to the 68 non-prescribing positive-alert HCPs.** These doctors have eligible patients and aren't prescribing anything. A single sales rep visit could unlock prescriptions. Prioritize HCP041 (127 alerts), HCP011 (118), HCP035 (112).

2. **Deploy a competitive detailing program against Rivalex.** Prepare head-to-head clinical comparison materials. Focus on HCPs where Rivalex has >40% share. Assign competitive intelligence reps to track Rivalex's sales activities.

3. **Assign a Key Account Manager to ACC001 (Northside General Hospital).** Investigate formulary status, physician awareness, and institutional barriers. If Nexavir isn't on formulary, begin the P&T committee submission process immediately.

### 6.3 Two-Minute Elevator Pitch (for non-technical audience)

> "We analyzed 18 months of PrimeRx data across 220 doctors, 23 hospitals, and 9,500 clinical alerts. The headline: 68 doctors are receiving strong signals that patients need Nexavir, but aren't prescribing it — that's our biggest opportunity. Rivalex is our main competitor, stealing share among our most active doctors. At the hospital level, Northside General generates the most alerts in the system but converts at the lowest rate. The good news: our alert program works — 64 doctors started prescribing for the first time after receiving alerts, and 25 others significantly increased their volume. We recommend allocating 50% of our quarterly sales capacity to these newly converted doctors, 35% to accelerating growers, and 15% to investigating non-responders. This data-driven approach will maximize our commercial ROI for the next quarter."

---

## 7. Technical Approach

### 7.1 Data Loading and Merging

```python
import pandas as pd

# Load all three sheets from Excel
alerts = pd.read_excel("PrimeRx Datasets.xlsx", sheet_name="Alerts")
sales  = pd.read_excel("PrimeRx Datasets.xlsx", sheet_name="Sales")
affil  = pd.read_excel("PrimeRx Datasets.xlsx", sheet_name="Affiliation")

# Normalize HCP_IDs (critical for correct merging)
alerts["HCP_ID"] = alerts["HCP_ID"].astype(str).str.strip().str.upper()
sales["HCP_ID"]  = sales["HCP_ID"].astype(str).str.strip().str.upper()
affil["HCP_ID"]  = affil["HCP_ID"].astype(str).str.strip().str.upper()

# Convert dates
alerts["Alert_Date"]       = pd.to_datetime(alerts["Alert_Date"])
sales["Prescription_Date"] = pd.to_datetime(sales["Prescription_Date"])
```

The `.str.strip().str.upper()` is essential because Excel data sometimes has leading/trailing whitespace or case inconsistencies that cause merge failures.

### 7.2 Date Calculations

**30-day window (Q2):**
```python
start = first_positive_date
end   = first_positive_date + pd.Timedelta(days=30)
# Check if any Rx falls in [start, end]
```

**90-day window (Q6):**
```python
pre_start  = first_positive_date - pd.Timedelta(days=90)
pre_end    = first_positive_date  # exclusive
post_start = first_positive_date  # exclusive
post_end   = first_positive_date + pd.Timedelta(days=90)
```

### 7.3 Edge Case Handling

| Edge Case | How We Handled It |
|-----------|------------------|
| Pre=0, Post=0 (Lift) | Classified as "Non-responder", Lift = 0% |
| Pre=0, Post>0 (Lift) | Classified as "New Starter", Lift = N/A (can't divide by zero) |
| HCP in Alerts but not in Sales | Shows as zero prescription volume — we don't impute |
| HCP in Alerts but not in Affiliation | Excluded from account-level analysis (Q4, Q5) |
| Accounts with 0 active prescribers | Excluded from Rx-per-doctor ratio (can't divide by zero) |

---

# 11. Conclusion — From Clinical Signals to Commercial Growth

This analysis demonstrates how raw healthcare data can be transformed into a complete commercial decision framework. By connecting clinical alerts, prescription behavior, and account relationships, we identified where PrimeRx is winning, where opportunities are being missed, and how the sales organization can act more strategically.

The biggest finding is that the challenge is not a lack of patient opportunity — the opportunity already exists. Thousands of positive clinical alerts show that doctors are seeing patients who may benefit from Nexavir. The real challenge is the **conversion gap** between clinical need and prescription action.

Our analysis uncovered three major commercial leakage points:

### 1. Alert-to-Prescription Leakage

A significant group of HCPs received repeated positive treatment signals but showed little or no prescribing activity.

These doctors represent immediate growth opportunities because:
- Patient need is already validated
- Awareness can be improved through targeted engagement
- Sales teams can focus on doctors with proven opportunity instead of broad outreach


---

### 2. Competitive Leakage

Prescription analysis showed that some high-value doctors are already treating patients but choosing competitor products instead of Nexavir.

This means PrimeRx does not only need patient identification — it also needs:

- Competitive positioning
- Doctor education
- Stronger relationship management

Winning these HCPs can directly shift existing market volume toward Nexavir.


---

### 3. Account-Level Opportunity

Hospital-level analysis revealed that some large accounts generate high clinical activity but have weak Nexavir adoption.

These accounts require:

- Key account management
- Institution-level engagement
- Formulary discussions
- Focused sales investment


---

# Final Strategic Recommendation

Instead of treating all doctors equally, PrimeRx should adopt a data-driven targeting strategy:

| Segment | Action |
|--------|--------|
| New Starters | Protect and nurture because alerts successfully converted them |
| Growers | Increase engagement to accelerate prescription growth |
| Competitor-heavy HCPs | Run competitive conversion campaigns |
| High-alert Non-prescribers | Prioritize sales follow-up |
| Low-response HCPs | Reduce low-return sales effort |


The recommended sales strategy focuses field-force capacity where the probability of conversion and return on investment is highest.

---

# Final Business Impact

Through this approach, PrimeRx can:

✔ Increase Nexavir market share  
✔ Recover lost prescriptions from competitors  
✔ Improve sales representative productivity  
✔ Convert clinical opportunities into revenue  
✔ Build a scalable analytics-driven commercial model  


---

# Closing Statement

The purpose of this analysis was not simply to find the doctors writing the most prescriptions — it was to understand **why prescriptions are not happening where clinical opportunities exist**.

By combining patient signals, physician behavior, competitor activity, and hospital networks, this project converts data into a clear commercial action plan:

> "Find the right doctors, target the right accounts, deliver the right intervention, and convert clinical need into patient impact."
