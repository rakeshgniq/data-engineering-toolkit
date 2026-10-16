-- SingleStore pipeline export (runnable / idempotent)
-- Database : pick_n_pay__validation
-- Generated: 20261014T103252Z (UTC)
-- Pipelines: 41
-- Note     : statements use CREATE OR REPLACE so this file
--            can be executed directly and repeatedly.
USE `pick_n_pay__validation`;

-- ======================================================================
-- Pipeline: cv_r_purchase_history_all_hist
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_purchase_history_all_hist`
AS LOAD DATA AZURE 'data-container/data/6200/output/data_load/col/json.gzip/cv_r_purchase_history/'
CONFIG '{\"suffixes\": [\"json.gz\"]}'
CREDENTIALS <CREDENTIALS REDACTED>
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
DISABLE OFFSETS METADATA GC
INTO PROCEDURE `cv_r_purchase_history_upsert_hist`
FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\'
LINES TERMINATED BY '\n' STARTING BY '';

-- ======================================================================
-- Pipeline: cv_r_shopping_attributes_all
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_shopping_attributes_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_shopping_attributes/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_shopping_attributes_all`
FORMAT Parquet
(
    `cv_r_shopping_attributes_all`.`cv_shopper_id` <- `cv_shopper_id`,
    `cv_r_shopping_attributes_all`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_shopping_attributes_all`.`rfv_tier_id` <- `rfv_tier_id`,
    `cv_r_shopping_attributes_all`.`rfv_tier` <- `rfv_tier`,
    `cv_r_shopping_attributes_all`.`tier_trend_id` <- `tier_trend_id`,
    `cv_r_shopping_attributes_all`.`tier_trend` <- `tier_trend`,
    `cv_r_shopping_attributes_all`.`basket_value_id` <- `basket_value_id`,
    `cv_r_shopping_attributes_all`.`basket_value` <- `basket_value`,
    `cv_r_shopping_attributes_all`.`basket_units_id` <- `basket_units_id`,
    `cv_r_shopping_attributes_all`.`basket_units` <- `basket_units`,
    `cv_r_shopping_attributes_all`.`frequency_id` <- `frequency_id`,
    `cv_r_shopping_attributes_all`.`frequency` <- `frequency`,
    `cv_r_shopping_attributes_all`.`recency_id` <- `recency_id`,
    `cv_r_shopping_attributes_all`.`recency` <- `recency`,
    `cv_r_shopping_attributes_all`.`first_id` <- `first_id`,
    `cv_r_shopping_attributes_all`.`first` <- `first`,
    `cv_r_shopping_attributes_all`.`churn_id` <- `churn_id`,
    `cv_r_shopping_attributes_all`.`churn` <- `churn`,
    `cv_r_shopping_attributes_all`.`long_period_value_id` <- `long_period_value_id`,
    `cv_r_shopping_attributes_all`.`long_period_value` <- `long_period_value`,
    `cv_r_shopping_attributes_all`.`long_period_value_discount_percentage_id` <- `long_period_value_discount_percentage_id`,
    `cv_r_shopping_attributes_all`.`short_period_value` <- `short_period_value`,
    `cv_r_shopping_attributes_all`.`long_period_visits_number` <- `long_period_visits_number`,
    `cv_r_shopping_attributes_all`.`short_period_visits_number` <- `short_period_visits_number`,
    `cv_r_shopping_attributes_all`.`short_period_value_discount_percentage` <- `short_period_value_discount_percentage`,
    `cv_r_shopping_attributes_all`.`long_period_value_discount_percentage` <- `long_period_value_discount_percentage`,
    `cv_r_shopping_attributes_all`.`visited_weeks` <- `visited_weeks`,
    `cv_r_shopping_attributes_all`.`wallet_share_id` <- `wallet_share_id`,
    `cv_r_shopping_attributes_all`.`wallet_share` <- `wallet_share`,
    `cv_r_shopping_attributes_all`.`relevancy_score` <- `relevancy_score`,
    `cv_r_shopping_attributes_all`.`nbo_id` <- `nbo_id`,
    `cv_r_shopping_attributes_all`.`digital_wallet_share_id` <- `digital_wallet_share_id`,
    `cv_r_shopping_attributes_all`.`digital_wallet_share` <- `digital_wallet_share`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_shopping_brand_attributes
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_shopping_brand_attributes`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_shopping_brand_attributes/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_shopping_brand_attributes`
FORMAT Parquet
(
    `cv_r_shopping_brand_attributes`.`cv_shopper_id` <- `cv_shopper_id`,
    `cv_r_shopping_brand_attributes`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_shopping_brand_attributes`.`recency` <- `recency`,
    `cv_r_shopping_brand_attributes`.`first` <- `first`,
    `cv_r_shopping_brand_attributes`.`period_value` <- `period_value`,
    `cv_r_shopping_brand_attributes`.`life_value` <- `life_value`,
    `cv_r_shopping_brand_attributes`.`life_units` <- `life_units`,
    `cv_r_shopping_brand_attributes`.`long_period_value` <- `long_period_value`,
    `cv_r_shopping_brand_attributes`.`long_period_line_discount_percentage` <- `long_period_line_discount_percentage`,
    `cv_r_shopping_brand_attributes`.`brand_loyalty_index` <- `brand_loyalty_index`,
    `cv_r_shopping_brand_attributes`.`short_period_value` <- `short_period_value`,
    `cv_r_shopping_brand_attributes`.`short_period_value_discount_percentage` <- `short_period_value_discount_percentage`,
    `cv_r_shopping_brand_attributes`.`long_period_value_discount_percentage` <- `long_period_value_discount_percentage`,
    `cv_r_shopping_brand_attributes`.`short_period_line_discount_percentage` <- `short_period_line_discount_percentage`,
    `cv_r_shopping_brand_attributes`.`visited_weeks` <- `visited_weeks`,
    `cv_r_shopping_brand_attributes`.`yearly_spent_value` <- `yearly_spent_value`,
    `cv_r_shopping_brand_attributes`.`relevancy_score` <- `relevancy_score`,
    `cv_r_shopping_brand_attributes`.`nbo_id` <- `nbo_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_shpr_attributes_dim_all
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_shpr_attributes_dim_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_shpr_attributes_dim/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_shpr_attributes_dim_all`
FORMAT Parquet
(
    `cv_r_shpr_attributes_dim_all`.`cv_shopper_id` <- `cv_shopper_id`,
    `cv_r_shpr_attributes_dim_all`.`shopper_rtlr_loyalty_id` <- `shopper_retailer_loyalty_id`,
    `cv_r_shpr_attributes_dim_all`.`preferred_pos_id` <- `preferred_pos_id`,
    `cv_r_shpr_attributes_dim_all`.`eligibility_channels` <- `eligibility_channels`,
    `cv_r_shpr_attributes_dim_all`.`security_hierarchy_id` <- `security_hierarchy_id`,
    `cv_r_shpr_attributes_dim_all`.`age` <- `age`,
    `cv_r_shpr_attributes_dim_all`.`attribute_0` <- `attribute_0`,
    `cv_r_shpr_attributes_dim_all`.`attribute_0_value` <- `attribute_0_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_100` <- `attribute_100`,
    `cv_r_shpr_attributes_dim_all`.`attribute_100_value` <- `attribute_100_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_1` <- `attribute_1`,
    `cv_r_shpr_attributes_dim_all`.`attribute_1_value` <- `attribute_1_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_2` <- `attribute_2`,
    `cv_r_shpr_attributes_dim_all`.`attribute_2_value` <- `attribute_2_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_3` <- `attribute_3`,
    `cv_r_shpr_attributes_dim_all`.`attribute_3_value` <- `attribute_3_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_4` <- `attribute_4`,
    `cv_r_shpr_attributes_dim_all`.`attribute_4_value` <- `attribute_4_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_5` <- `attribute_5`,
    `cv_r_shpr_attributes_dim_all`.`attribute_5_value` <- `attribute_5_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_6` <- `attribute_6`,
    `cv_r_shpr_attributes_dim_all`.`attribute_6_value` <- `attribute_6_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_7` <- `attribute_7`,
    `cv_r_shpr_attributes_dim_all`.`attribute_7_value` <- `attribute_7_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_8` <- `attribute_8`,
    `cv_r_shpr_attributes_dim_all`.`attribute_8_value` <- `attribute_8_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_9` <- `attribute_9`,
    `cv_r_shpr_attributes_dim_all`.`attribute_9_value` <- `attribute_9_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_10` <- `attribute_10`,
    `cv_r_shpr_attributes_dim_all`.`attribute_10_value` <- `attribute_10_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_11` <- `attribute_11`,
    `cv_r_shpr_attributes_dim_all`.`attribute_11_value` <- `attribute_11_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_12` <- `attribute_12`,
    `cv_r_shpr_attributes_dim_all`.`attribute_12_value` <- `attribute_12_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_13` <- `attribute_13`,
    `cv_r_shpr_attributes_dim_all`.`attribute_13_value` <- `attribute_13_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_14` <- `attribute_14`,
    `cv_r_shpr_attributes_dim_all`.`attribute_14_value` <- `attribute_14_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_15` <- `attribute_15`,
    `cv_r_shpr_attributes_dim_all`.`attribute_15_value` <- `attribute_15_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_16` <- `attribute_16`,
    `cv_r_shpr_attributes_dim_all`.`attribute_16_value` <- `attribute_16_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_17` <- `attribute_17`,
    `cv_r_shpr_attributes_dim_all`.`attribute_17_value` <- `attribute_17_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_18` <- `attribute_18`,
    `cv_r_shpr_attributes_dim_all`.`attribute_18_value` <- `attribute_18_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_19` <- `attribute_19`,
    `cv_r_shpr_attributes_dim_all`.`attribute_19_value` <- `attribute_19_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_20` <- `attribute_20`,
    `cv_r_shpr_attributes_dim_all`.`attribute_20_value` <- `attribute_20_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_21` <- `attribute_21`,
    `cv_r_shpr_attributes_dim_all`.`attribute_21_value` <- `attribute_21_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_22` <- `attribute_22`,
    `cv_r_shpr_attributes_dim_all`.`attribute_22_value` <- `attribute_22_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_23` <- `attribute_23`,
    `cv_r_shpr_attributes_dim_all`.`attribute_23_value` <- `attribute_23_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_24` <- `attribute_24`,
    `cv_r_shpr_attributes_dim_all`.`attribute_24_value` <- `attribute_24_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_25` <- `attribute_25`,
    `cv_r_shpr_attributes_dim_all`.`attribute_25_value` <- `attribute_25_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_26` <- `attribute_26`,
    `cv_r_shpr_attributes_dim_all`.`attribute_26_value` <- `attribute_26_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_27` <- `attribute_27`,
    `cv_r_shpr_attributes_dim_all`.`attribute_27_value` <- `attribute_27_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_28` <- `attribute_28`,
    `cv_r_shpr_attributes_dim_all`.`attribute_28_value` <- `attribute_28_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_29` <- `attribute_29`,
    `cv_r_shpr_attributes_dim_all`.`attribute_29_value` <- `attribute_29_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_30` <- `attribute_30`,
    `cv_r_shpr_attributes_dim_all`.`attribute_30_value` <- `attribute_30_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_31` <- `attribute_31`,
    `cv_r_shpr_attributes_dim_all`.`attribute_31_value` <- `attribute_31_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_32` <- `attribute_32`,
    `cv_r_shpr_attributes_dim_all`.`attribute_32_value` <- `attribute_32_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_33` <- `attribute_33`,
    `cv_r_shpr_attributes_dim_all`.`attribute_33_value` <- `attribute_33_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_34` <- `attribute_34`,
    `cv_r_shpr_attributes_dim_all`.`attribute_34_value` <- `attribute_34_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_35` <- `attribute_35`,
    `cv_r_shpr_attributes_dim_all`.`attribute_35_value` <- `attribute_35_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_36` <- `attribute_36`,
    `cv_r_shpr_attributes_dim_all`.`attribute_36_value` <- `attribute_36_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_37` <- `attribute_37`,
    `cv_r_shpr_attributes_dim_all`.`attribute_37_value` <- `attribute_37_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_38` <- `attribute_38`,
    `cv_r_shpr_attributes_dim_all`.`attribute_38_value` <- `attribute_38_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_39` <- `attribute_39`,
    `cv_r_shpr_attributes_dim_all`.`attribute_39_value` <- `attribute_39_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_40` <- `attribute_40`,
    `cv_r_shpr_attributes_dim_all`.`attribute_40_value` <- `attribute_40_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_41` <- `attribute_41`,
    `cv_r_shpr_attributes_dim_all`.`attribute_41_value` <- `attribute_41_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_42` <- `attribute_42`,
    `cv_r_shpr_attributes_dim_all`.`attribute_42_value` <- `attribute_42_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_43` <- `attribute_43`,
    `cv_r_shpr_attributes_dim_all`.`attribute_43_value` <- `attribute_43_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_44` <- `attribute_44`,
    `cv_r_shpr_attributes_dim_all`.`attribute_44_value` <- `attribute_44_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_45` <- `attribute_45`,
    `cv_r_shpr_attributes_dim_all`.`attribute_45_value` <- `attribute_45_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_46` <- `attribute_46`,
    `cv_r_shpr_attributes_dim_all`.`attribute_46_value` <- `attribute_46_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_101` <- `attribute_101`,
    `cv_r_shpr_attributes_dim_all`.`attribute_101_value` <- `attribute_101_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_102` <- `attribute_102`,
    `cv_r_shpr_attributes_dim_all`.`attribute_102_value` <- `attribute_102_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_103` <- `attribute_103`,
    `cv_r_shpr_attributes_dim_all`.`attribute_103_value` <- `attribute_103_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_104` <- `attribute_104`,
    `cv_r_shpr_attributes_dim_all`.`attribute_104_value` <- `attribute_104_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_105` <- `attribute_105`,
    `cv_r_shpr_attributes_dim_all`.`attribute_105_value` <- `attribute_105_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_106` <- `attribute_106`,
    `cv_r_shpr_attributes_dim_all`.`attribute_106_value` <- `attribute_106_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_107` <- `attribute_107`,
    `cv_r_shpr_attributes_dim_all`.`attribute_107_value` <- `attribute_107_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_108` <- `attribute_108`,
    `cv_r_shpr_attributes_dim_all`.`attribute_108_value` <- `attribute_108_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_109` <- `attribute_109`,
    `cv_r_shpr_attributes_dim_all`.`attribute_109_value` <- `attribute_109_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_110` <- `attribute_110`,
    `cv_r_shpr_attributes_dim_all`.`attribute_110_value` <- `attribute_110_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_111` <- `attribute_111`,
    `cv_r_shpr_attributes_dim_all`.`attribute_111_value` <- `attribute_111_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_112` <- `attribute_112`,
    `cv_r_shpr_attributes_dim_all`.`attribute_112_value` <- `attribute_112_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_113` <- `attribute_113`,
    `cv_r_shpr_attributes_dim_all`.`attribute_113_value` <- `attribute_113_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_114` <- `attribute_114`,
    `cv_r_shpr_attributes_dim_all`.`attribute_114_value` <- `attribute_114_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_115` <- `attribute_115`,
    `cv_r_shpr_attributes_dim_all`.`attribute_115_value` <- `attribute_115_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_116` <- `attribute_116`,
    `cv_r_shpr_attributes_dim_all`.`attribute_116_value` <- `attribute_116_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_117` <- `attribute_117`,
    `cv_r_shpr_attributes_dim_all`.`attribute_117_value` <- `attribute_117_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_118` <- `attribute_118`,
    `cv_r_shpr_attributes_dim_all`.`attribute_118_value` <- `attribute_118_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_119` <- `attribute_119`,
    `cv_r_shpr_attributes_dim_all`.`attribute_119_value` <- `attribute_119_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_120` <- `attribute_120`,
    `cv_r_shpr_attributes_dim_all`.`attribute_120_value` <- `attribute_120_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_121` <- `attribute_121`,
    `cv_r_shpr_attributes_dim_all`.`attribute_121_value` <- `attribute_121_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_122` <- `attribute_122`,
    `cv_r_shpr_attributes_dim_all`.`attribute_122_value` <- `attribute_122_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_123` <- `attribute_123`,
    `cv_r_shpr_attributes_dim_all`.`attribute_123_value` <- `attribute_123_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_124` <- `attribute_124`,
    `cv_r_shpr_attributes_dim_all`.`attribute_124_value` <- `attribute_124_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_125` <- `attribute_125`,
    `cv_r_shpr_attributes_dim_all`.`attribute_125_value` <- `attribute_125_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_126` <- `attribute_126`,
    `cv_r_shpr_attributes_dim_all`.`attribute_126_value` <- `attribute_126_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_127` <- `attribute_127`,
    `cv_r_shpr_attributes_dim_all`.`attribute_127_value` <- `attribute_127_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_128` <- `attribute_128`,
    `cv_r_shpr_attributes_dim_all`.`attribute_128_value` <- `attribute_128_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_129` <- `attribute_129`,
    `cv_r_shpr_attributes_dim_all`.`attribute_129_value` <- `attribute_129_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_130` <- `attribute_130`,
    `cv_r_shpr_attributes_dim_all`.`attribute_130_value` <- `attribute_130_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_131` <- `attribute_131`,
    `cv_r_shpr_attributes_dim_all`.`attribute_131_value` <- `attribute_131_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_132` <- `attribute_132`,
    `cv_r_shpr_attributes_dim_all`.`attribute_132_value` <- `attribute_132_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_133` <- `attribute_133`,
    `cv_r_shpr_attributes_dim_all`.`attribute_133_value` <- `attribute_133_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_134` <- `attribute_134`,
    `cv_r_shpr_attributes_dim_all`.`attribute_134_value` <- `attribute_134_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_135` <- `attribute_135`,
    `cv_r_shpr_attributes_dim_all`.`attribute_135_value` <- `attribute_135_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_136` <- `attribute_136`,
    `cv_r_shpr_attributes_dim_all`.`attribute_136_value` <- `attribute_136_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_137` <- `attribute_137`,
    `cv_r_shpr_attributes_dim_all`.`attribute_137_value` <- `attribute_137_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_138` <- `attribute_138`,
    `cv_r_shpr_attributes_dim_all`.`attribute_138_value` <- `attribute_138_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_139` <- `attribute_139`,
    `cv_r_shpr_attributes_dim_all`.`attribute_139_value` <- `attribute_139_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_140` <- `attribute_140`,
    `cv_r_shpr_attributes_dim_all`.`attribute_140_value` <- `attribute_140_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_141` <- `attribute_141`,
    `cv_r_shpr_attributes_dim_all`.`attribute_141_value` <- `attribute_141_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_142` <- `attribute_142`,
    `cv_r_shpr_attributes_dim_all`.`attribute_142_value` <- `attribute_142_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_143` <- `attribute_143`,
    `cv_r_shpr_attributes_dim_all`.`attribute_143_value` <- `attribute_143_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_144` <- `attribute_144`,
    `cv_r_shpr_attributes_dim_all`.`attribute_144_value` <- `attribute_144_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_145` <- `attribute_145`,
    `cv_r_shpr_attributes_dim_all`.`attribute_145_value` <- `attribute_145_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_146` <- `attribute_146`,
    `cv_r_shpr_attributes_dim_all`.`attribute_146_value` <- `attribute_146_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_147` <- `attribute_147`,
    `cv_r_shpr_attributes_dim_all`.`attribute_147_value` <- `attribute_147_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_148` <- `attribute_148`,
    `cv_r_shpr_attributes_dim_all`.`attribute_148_value` <- `attribute_148_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_149` <- `attribute_149`,
    `cv_r_shpr_attributes_dim_all`.`attribute_149_value` <- `attribute_149_value`,
    `cv_r_shpr_attributes_dim_all`.`attribute_150` <- `attribute_150`,
    `cv_r_shpr_attributes_dim_all`.`attribute_150_value` <- `attribute_150_value`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_virtual_category_attributes
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_virtual_category_attributes`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_virtual_category_attributes/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_virtual_category_attributes`
FORMAT Parquet
(
    `cv_r_virtual_category_attributes`.`cv_shopper_id` <- `cv_shopper_id`,
    `cv_r_virtual_category_attributes`.`cv_attribute_id` <- `cv_product_item_id`,
    `cv_r_virtual_category_attributes`.`rfv_tier_id` <- `rfv_tier_id`,
    `cv_r_virtual_category_attributes`.`rfv_tier` <- `rfv_tier`,
    `cv_r_virtual_category_attributes`.`tier_trend_id` <- `tier_trend_id`,
    `cv_r_virtual_category_attributes`.`tier_trend` <- `tier_trend`,
    `cv_r_virtual_category_attributes`.`basket_value_id` <- `basket_value_id`,
    `cv_r_virtual_category_attributes`.`basket_value` <- `basket_value`,
    `cv_r_virtual_category_attributes`.`basket_units_id` <- `basket_units_id`,
    `cv_r_virtual_category_attributes`.`basket_units` <- `basket_units`,
    `cv_r_virtual_category_attributes`.`frequency_id` <- `frequency_id`,
    `cv_r_virtual_category_attributes`.`frequency` <- `frequency`,
    `cv_r_virtual_category_attributes`.`recency_id` <- `recency_id`,
    `cv_r_virtual_category_attributes`.`recency` <- `recency`,
    `cv_r_virtual_category_attributes`.`first_id` <- `first_id`,
    `cv_r_virtual_category_attributes`.`first` <- `first`,
    `cv_r_virtual_category_attributes`.`churn_id` <- `churn_id`,
    `cv_r_virtual_category_attributes`.`churn` <- `churn`,
    `cv_r_virtual_category_attributes`.`long_period_value_id` <- `long_period_value_id`,
    `cv_r_virtual_category_attributes`.`long_period_value` <- `long_period_value`,
    `cv_r_virtual_category_attributes`.`long_period_value_discount_percentage_id` <- `long_period_value_discount_percentage_id`,
    `cv_r_virtual_category_attributes`.`short_period_value` <- `short_period_value`,
    `cv_r_virtual_category_attributes`.`long_period_visits_number` <- `long_period_visits_number`,
    `cv_r_virtual_category_attributes`.`short_period_visits_number` <- `short_period_visits_number`,
    `cv_r_virtual_category_attributes`.`short_period_value_discount_percentage` <- `short_period_value_discount_percentage`,
    `cv_r_virtual_category_attributes`.`long_period_value_discount_percentage` <- `long_period_value_discount_percentage`,
    `cv_r_virtual_category_attributes`.`visited_weeks` <- `visited_weeks`,
    `cv_r_virtual_category_attributes`.`wallet_share_id` <- `wallet_share_id`,
    `cv_r_virtual_category_attributes`.`wallet_share` <- `wallet_share`,
    `cv_r_virtual_category_attributes`.`relevancy_score` <- `relevancy_score`,
    `cv_r_virtual_category_attributes`.`nbo_id` <- `nbo_id`,
    `cv_r_virtual_category_attributes`.`digital_wallet_share_id` <- `digital_wallet_share_id`,
    `cv_r_virtual_category_attributes`.`digital_wallet_share` <- `digital_wallet_share`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_permutation_all_roles
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_permutation_all_roles`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_permutation_roles/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_permutation_all_roles`
FORMAT Parquet
(
    `cv_r_permutation_all_roles`.`hier` <- `hier`,
    `cv_r_permutation_all_roles`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_permutation_all_roles`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_1` <- `ACCESS_ROLES1`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_2` <- `ACCESS_ROLES2`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_3` <- `ACCESS_ROLES3`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_4` <- `ACCESS_ROLES4`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_5` <- `ACCESS_ROLES5`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_6` <- `ACCESS_ROLES6`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_7` <- `ACCESS_ROLES7`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_8` <- `ACCESS_ROLES8`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_9` <- `ACCESS_ROLES9`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_10` <- `ACCESS_ROLES10`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_11` <- `ACCESS_ROLES11`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_12` <- `ACCESS_ROLES12`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_13` <- `ACCESS_ROLES13`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_14` <- `ACCESS_ROLES14`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_15` <- `ACCESS_ROLES15`,
    `cv_r_permutation_all_roles`.`ACCESS_ROLES_17` <- `ACCESS_ROLES17`,
    `cv_r_permutation_all_roles`.`PRODUCT_ATTR_ACCESS_ROLES` <- `product_attr_access_roles_1`,
    `cv_r_permutation_all_roles`.`STORE_ATTR_ACCESS_ROLES` <- `store_attr_access_roles_1`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_attributes_values_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_attributes_values_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_attributes_values_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_attributes_values_dim`
FORMAT Parquet
(
    `cv_r_attributes_values_dim`.`attribute_id` <- `attribute_id`,
    `cv_r_attributes_values_dim`.`attribute_type` <- `attribute_type`,
    `cv_r_attributes_values_dim`.`attribute_value_id` <- `attribute_value_id`,
    `cv_r_attributes_values_dim`.`attribute_value_code` <- `attribute_value_code`,
    `cv_r_attributes_values_dim`.`attribute_value_description` <- `attribute_value_description`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_life_value_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_life_value_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_life_value_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_life_value_bins_dim`
FORMAT Parquet
(
    `cv_r_life_value_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_life_value_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_life_value_bins_dim`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_life_value_bins_dim`.`product_tree_level` <- `product_tree_level`,
    `cv_r_life_value_bins_dim`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_life_value_bins_dim`.`catalog_id` <- `catalog_id`,
    `cv_r_life_value_bins_dim`.`from_val` <- `from_val`,
    `cv_r_life_value_bins_dim`.`to_val` <- `to_val`,
    `cv_r_life_value_bins_dim`.`rank` <- `rank`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_basket_units_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_basket_units_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_basket_units_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_basket_units_bins_dim`
FORMAT Parquet
(
    `cv_r_basket_units_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_basket_units_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_basket_units_bins_dim`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_basket_units_bins_dim`.`product_tree_level` <- `product_tree_level`,
    `cv_r_basket_units_bins_dim`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_basket_units_bins_dim`.`catalog_id` <- `catalog_id`,
    `cv_r_basket_units_bins_dim`.`from_val` <- `from_val`,
    `cv_r_basket_units_bins_dim`.`to_val` <- `to_val`,
    `cv_r_basket_units_bins_dim`.`rank` <- `rank`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_basket_value_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_basket_value_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_basket_value_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_basket_value_bins_dim`
FORMAT Parquet
(
    `cv_r_basket_value_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_basket_value_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_basket_value_bins_dim`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_basket_value_bins_dim`.`product_tree_level` <- `product_tree_level`,
    `cv_r_basket_value_bins_dim`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_basket_value_bins_dim`.`catalog_id` <- `catalog_id`,
    `cv_r_basket_value_bins_dim`.`from_val` <- `from_val`,
    `cv_r_basket_value_bins_dim`.`to_val` <- `to_val`,
    `cv_r_basket_value_bins_dim`.`rank` <- `rank`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_catalog_brand_dim_all
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_catalog_brand_dim_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_catalog_brand_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_catalog_brand_dim_all`
FORMAT Parquet
(
    `cv_r_catalog_brand_dim_all`.`internal_id` <- `internal_id`,
    `cv_r_catalog_brand_dim_all`.`status` <- `status`,
    `cv_r_catalog_brand_dim_all`.`cv_sub_brand_id` <- `cv_sub_brand_id`,
    `cv_r_catalog_brand_dim_all`.`cv_brand_id` <- `cv_brand_id`,
    `cv_r_catalog_brand_dim_all`.`cv_high_brand_id` <- `cv_high_brand_id`,
    `cv_r_catalog_brand_dim_all`.`cv_cpg_id` <- `cv_cpg_id`,
    `cv_r_catalog_brand_dim_all`.`level_-3_id` <- `level_-3_id`,
    `cv_r_catalog_brand_dim_all`.`level_-3_desc` <- `level_-3_desc`,
    `cv_r_catalog_brand_dim_all`.`level_-2_id` <- `level_-2_id`,
    `cv_r_catalog_brand_dim_all`.`level_-2_desc` <- `level_-2_desc`,
    `cv_r_catalog_brand_dim_all`.`level_-1_id` <- `level_-1_id`,
    `cv_r_catalog_brand_dim_all`.`level_-1_desc` <- `level_-1_desc`,
    `cv_r_catalog_brand_dim_all`.`level_0_id` <- `level_0_id`,
    `cv_r_catalog_brand_dim_all`.`level_0_desc` <- `level_0_desc`,
    `cv_r_catalog_brand_dim_all`.`level_1_id` <- `level_1_id`,
    `cv_r_catalog_brand_dim_all`.`level_1_desc` <- `level_1_desc`,
    `cv_r_catalog_brand_dim_all`.`level_2_id` <- `level_2_id`,
    `cv_r_catalog_brand_dim_all`.`level_2_desc` <- `level_2_desc`,
    `cv_r_catalog_brand_dim_all`.`level_3_id` <- `level_3_id`,
    `cv_r_catalog_brand_dim_all`.`level_3_desc` <- `level_3_desc`,
    `cv_r_catalog_brand_dim_all`.`level_4_id` <- `level_4_id`,
    `cv_r_catalog_brand_dim_all`.`level_4_desc` <- `level_4_desc`,
    `cv_r_catalog_brand_dim_all`.`level_5_id` <- `level_5_id`,
    `cv_r_catalog_brand_dim_all`.`level_5_desc` <- `level_5_desc`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_catalog_dim_all
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_catalog_dim_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_catalog_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_catalog_dim_all`
FORMAT Parquet
(
    `cv_r_catalog_dim_all`.`internal_id` <- `internal_id`,
    `cv_r_catalog_dim_all`.`product_tree_level` <- `product_tree_level`,
    `cv_r_catalog_dim_all`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_catalog_dim_all`.`product_tree_level_description` <- `product_tree_level_description`,
    `cv_r_catalog_dim_all`.`cv_parent_id` <- `cv_parent_id`,
    `cv_r_catalog_dim_all`.`parent_tree_level` <- `parent_tree_level`,
    `cv_r_catalog_dim_all`.`parent_tree_level_id` <- `parent_tree_level_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_catalog_product_brand_dim_all
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_catalog_product_brand_dim_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_catalog_product_brand_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_catalog_product_brand_dim_all`
FORMAT Parquet
(
    `cv_r_catalog_product_brand_dim_all`.`internal_id` <- `internal_id`,
    `cv_r_catalog_product_brand_dim_all`.`cv_sub_brand_id` <- `cv_sub_brand_id`,
    `cv_r_catalog_product_brand_dim_all`.`cv_brand_id` <- `cv_brand_id`,
    `cv_r_catalog_product_brand_dim_all`.`cv_high_brand_id` <- `cv_high_brand_id`,
    `cv_r_catalog_product_brand_dim_all`.`cv_cpg_id` <- `cv_cpg_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_-3_id` <- `level_-3_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_-2_id` <- `level_-2_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_-1_id` <- `level_-1_id`,
    `cv_r_catalog_product_brand_dim_all`.`product_id` <- `product_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_0_id` <- `level_0_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_1_id` <- `level_1_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_2_id` <- `level_2_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_3_id` <- `level_3_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_4_id` <- `level_4_id`,
    `cv_r_catalog_product_brand_dim_all`.`level_5_id` <- `level_5_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_cpg_brand_dim_all
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_cpg_brand_dim_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_cpg_brand_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_cpg_brand_dim_all`
FORMAT Parquet
(
    `cv_r_cpg_brand_dim_all`.`internal_id` <- `internal_id`,
    `cv_r_cpg_brand_dim_all`.`level_3_id` <- `level_3_id`,
    `cv_r_cpg_brand_dim_all`.`level_3_desc` <- `level_3_desc`,
    `cv_r_cpg_brand_dim_all`.`level_2_id` <- `level_2_id`,
    `cv_r_cpg_brand_dim_all`.`level_2_desc` <- `level_2_desc`,
    `cv_r_cpg_brand_dim_all`.`level_1_id` <- `level_1_id`,
    `cv_r_cpg_brand_dim_all`.`level_1_desc` <- `level_1_desc`,
    `cv_r_cpg_brand_dim_all`.`level_0_id` <- `level_0_id`,
    `cv_r_cpg_brand_dim_all`.`level_0_desc` <- `level_0_desc`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_long_period_value_discount_percentage_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_long_period_value_discount_percentage_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_long_period_value_discount_percentage_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_long_period_value_discount_percentage_bins_dim`
FORMAT Parquet
(
    `cv_r_long_period_value_discount_percentage_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`product_tree_level` <- `product_tree_level`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`catalog_id` <- `catalog_id`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`from_val` <- `from_val`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`to_val` <- `to_val`,
    `cv_r_long_period_value_discount_percentage_bins_dim`.`rank` <- `rank`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_long_period_value_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_long_period_value_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_long_period_value_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_long_period_value_bins_dim`
FORMAT Parquet
(
    `cv_r_long_period_value_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_long_period_value_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_long_period_value_bins_dim`.`cv_product_item_id` <- `cv_product_item_id`,
    `cv_r_long_period_value_bins_dim`.`product_tree_level` <- `product_tree_level`,
    `cv_r_long_period_value_bins_dim`.`product_tree_level_id` <- `product_tree_level_id`,
    `cv_r_long_period_value_bins_dim`.`catalog_id` <- `catalog_id`,
    `cv_r_long_period_value_bins_dim`.`from_val` <- `from_val`,
    `cv_r_long_period_value_bins_dim`.`to_val` <- `to_val`,
    `cv_r_long_period_value_bins_dim`.`rank` <- `rank`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_all_parents
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_all_parents`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_all_parents/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_all_parents`
FORMAT Parquet
(
    `cv_r_all_parents`.`hierarchy` <- `hierarchy`,
    `cv_r_all_parents`.`hier` <- `hier`,
    `cv_r_all_parents`.`child_id` <- `child_id`,
    `cv_r_all_parents`.`child_level` <- `child_level`,
    `cv_r_all_parents`.`parent_id` <- `parent_id`,
    `cv_r_all_parents`.`parent_level` <- `parent_level`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_hierarchy_description
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_hierarchy_description`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_hierarchy_description/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_hierarchy_description`
FORMAT Parquet
(
    `cv_r_hierarchy_description`.`hier` <- `hier`,
    `cv_r_hierarchy_description`.`child_id` <- `child_id`,
    `cv_r_hierarchy_description`.`child_level` <- `child_level`,
    `cv_r_hierarchy_description`.`tree_level_id` <- `tree_level_id`,
    `cv_r_hierarchy_description`.`short_description` <- `short_description`,
    `cv_r_hierarchy_description`.`long_description` <- `long_description`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_security_base
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_security_base`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_security_base/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_security_base`
FORMAT Parquet
(
    `cv_r_security_base`.`hierarchy` <- `hierarchy`,
    `cv_r_security_base`.`hier` <- `hier`,
    `cv_r_security_base`.`cv_id` <- `cv_id`,
    `cv_r_security_base`.`cv_level_id` <- `cv_level_id`,
    `cv_r_security_base`.`ACCESS_ROLES` <- `ACCESS_ROLE`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_shpr_active_period_dim
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_shpr_active_period_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_shpr_active_period_dim/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_shpr_active_period_dim`
FORMAT Parquet
(
    `cv_r_shpr_active_period_dim`.`cv_shopper_id` <- `cv_shopper_id`,
    @from_ts <- `from_date`,
    @to_ts <- `to_date`
)
SET
    `from_date` = DATE_ADD('1970-01-01', INTERVAL @from_ts DAY),
    `to_date` = DATE_ADD('1970-01-01', INTERVAL @to_ts DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_shpr_attributes_history_dim
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_shpr_attributes_history_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_shpr_attributes_history_dim/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_shpr_attributes_history_dim`
FORMAT Parquet
(
    `cv_r_shpr_attributes_history_dim`.`cv_shopper_id` <- `cv_shopper_id`,
    `cv_r_shpr_attributes_history_dim`.`attribute_id` <- `attribute_id`,
    `cv_r_shpr_attributes_history_dim`.`attribute_value_id` <- `attribute_value_id`,
    @from_ts <- `from_date`,
    @to_ts <- `to_date`
)
SET
    `from_date` = DATE_ADD('1970-01-01', INTERVAL @from_ts DAY),
    `to_date` = DATE_ADD('1970-01-01', INTERVAL @to_ts DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_product_parents_flat
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_product_parents_flat`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_product_parents_flat/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_product_parents_flat`
FORMAT Parquet
(
    `cv_r_product_parents_flat`.`catalog_internal_id` <- `child_id`,
    `cv_r_product_parents_flat`.`cv_hier_1_level_1` <- `cv_hier_1_level_1`,
    `cv_r_product_parents_flat`.`cv_hier_1_level_2` <- `cv_hier_1_level_2`,
    `cv_r_product_parents_flat`.`cv_hier_1_level_3` <- `cv_hier_1_level_3`,
    `cv_r_product_parents_flat`.`cv_hier_1_level_4` <- `cv_hier_1_level_4`,
    `cv_r_product_parents_flat`.`cv_hier_1_level_5` <- `cv_hier_1_level_5`,
    `cv_r_product_parents_flat`.`cv_hier_2_level_0` <- `cv_hier_2_level_0`,
    `cv_r_product_parents_flat`.`cv_hier_2_level_1` <- `cv_hier_2_level_1`,
    `cv_r_product_parents_flat`.`cv_hier_2_level_2` <- `cv_hier_2_level_2`,
    `cv_r_product_parents_flat`.`cv_hier_2_level_3` <- `cv_hier_2_level_3`,
    `cv_r_product_parents_flat`.`cv_hier_4_level_0` <- `cv_hier_4_level_0`,
    `cv_r_product_parents_flat`.`cv_hier_4_level_1` <- `cv_hier_4_level_1`,
    `cv_r_product_parents_flat`.`cv_hier_4_level_2` <- `cv_hier_4_level_2`,
    `cv_r_product_parents_flat`.`cv_hier_4_level_3` <- `cv_hier_4_level_3`,
    `cv_r_product_parents_flat`.`cv_hier_14_level_0` <- `cv_hier_14_level_0`,
    `cv_r_product_parents_flat`.`cv_hier_14_level_1` <- `cv_hier_14_level_1`,
    `cv_r_product_parents_flat`.`cv_hier_15_level_0` <- `cv_hier_15_level_0`,
    `cv_r_product_parents_flat`.`cv_hier_15_level_1` <- `cv_hier_15_level_1`,
    `cv_r_product_parents_flat`.`cv_hier_15_level_2` <- `cv_hier_15_level_2`,
    `cv_r_product_parents_flat`.`cv_hier_15_level_3` <- `cv_hier_15_level_3`,
    `cv_r_product_parents_flat`.`access_roles_1` <- `access_roles_1`,
    `cv_r_product_parents_flat`.`access_roles_2` <- `access_roles_2`,
    `cv_r_product_parents_flat`.`access_roles_4` <- `access_roles_4`,
    `cv_r_product_parents_flat`.`access_roles_14` <- `access_roles_14`,
    `cv_r_product_parents_flat`.`access_roles_15` <- `access_roles_15`,
    `cv_r_product_parents_flat`.`product_attr_access_roles` <- `attr_access_roles_1`,
    `cv_r_product_parents_flat`.`product_barcode` <- `product_barcode`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_attributes_values_numeric_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_attributes_values_numeric_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_attributes_values_numeric_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_attributes_values_numeric_dim`
FORMAT Parquet
(
    `cv_r_attributes_values_numeric_dim`.`attribute_id` <- `attribute_id`,
    `cv_r_attributes_values_numeric_dim`.`attribute_type` <- `attribute_type`,
    `cv_r_attributes_values_numeric_dim`.`attribute_value_id` <- `attribute_value_id`,
    `cv_r_attributes_values_numeric_dim`.`attribute_value_code` <- `attribute_value_code`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_invoice_permutations
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_invoice_permutations`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_invoice_permutations/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_invoice_permutation_all`
FORMAT Parquet
(
    `cv_r_invoice_permutation_all`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_invoice_permutation_all`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_invoice_permutation_all`.`attribute_s_1` <- `attribute_s_1`,
    `cv_r_invoice_permutation_all`.`attribute_s_2` <- `attribute_s_2`,
    `cv_r_invoice_permutation_all`.`attribute_s_3` <- `attribute_s_3`,
    `cv_r_invoice_permutation_all`.`attribute_s_4` <- `attribute_s_4`,
    `cv_r_invoice_permutation_all`.`attribute_s_5` <- `attribute_s_5`,
    `cv_r_invoice_permutation_all`.`attribute_s_6` <- `attribute_s_6`,
    `cv_r_invoice_permutation_all`.`attribute_s_7` <- `attribute_s_7`,
    `cv_r_invoice_permutation_all`.`attribute_s_8` <- `attribute_s_8`,
    `cv_r_invoice_permutation_all`.`attribute_s_9` <- `attribute_s_9`,
    `cv_r_invoice_permutation_all`.`attribute_s_10` <- `attribute_s_10`,
    `cv_r_invoice_permutation_all`.`attribute_c_1` <- `attribute_c_1`,
    `cv_r_invoice_permutation_all`.`attribute_c_2` <- `attribute_c_2`,
    `cv_r_invoice_permutation_all`.`attribute_c_3` <- `attribute_c_3`,
    `cv_r_invoice_permutation_all`.`attribute_c_4` <- `attribute_c_4`,
    `cv_r_invoice_permutation_all`.`attribute_c_5` <- `attribute_c_5`,
    `cv_r_invoice_permutation_all`.`attribute_c_6` <- `attribute_c_6`,
    `cv_r_invoice_permutation_all`.`attribute_c_7` <- `attribute_c_7`,
    `cv_r_invoice_permutation_all`.`attribute_c_8` <- `attribute_c_8`,
    `cv_r_invoice_permutation_all`.`attribute_c_9` <- `attribute_c_9`,
    `cv_r_invoice_permutation_all`.`attribute_c_10` <- `attribute_c_10`,
    `cv_r_invoice_permutation_all`.`attribute_c_11` <- `attribute_c_11`,
    `cv_r_invoice_permutation_all`.`attribute_c_12` <- `attribute_c_12`,
    `cv_r_invoice_permutation_all`.`attribute_c_13` <- `attribute_c_13`,
    `cv_r_invoice_permutation_all`.`attribute_c_14` <- `attribute_c_14`,
    `cv_r_invoice_permutation_all`.`attribute_c_15` <- `attribute_c_15`,
    `cv_r_invoice_permutation_all`.`attribute_c_16` <- `attribute_c_16`,
    `cv_r_invoice_permutation_all`.`attribute_c_17` <- `attribute_c_17`,
    `cv_r_invoice_permutation_all`.`attribute_c_18` <- `attribute_c_18`,
    `cv_r_invoice_permutation_all`.`attribute_c_19` <- `attribute_c_19`,
    `cv_r_invoice_permutation_all`.`attribute_c_20` <- `attribute_c_20`,
    `cv_r_invoice_permutation_all`.`attribute_c_21` <- `attribute_c_21`,
    `cv_r_invoice_permutation_all`.`attribute_c_22` <- `attribute_c_22`,
    `cv_r_invoice_permutation_all`.`attribute_c_23` <- `attribute_c_23`,
    `cv_r_invoice_permutation_all`.`attribute_c_24` <- `attribute_c_24`,
    `cv_r_invoice_permutation_all`.`attribute_c_25` <- `attribute_c_25`,
    `cv_r_invoice_permutation_all`.`attribute_c_26` <- `attribute_c_26`,
    `cv_r_invoice_permutation_all`.`attribute_c_27` <- `attribute_c_27`,
    `cv_r_invoice_permutation_all`.`attribute_c_28` <- `attribute_c_28`,
    `cv_r_invoice_permutation_all`.`attribute_c_29` <- `attribute_c_29`,
    `cv_r_invoice_permutation_all`.`attribute_c_30` <- `attribute_c_30`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_1` <- `ACCESS_ROLES1`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_2` <- `ACCESS_ROLES2`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_3` <- `ACCESS_ROLES3`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_4` <- `ACCESS_ROLES4`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_5` <- `ACCESS_ROLES5`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_6` <- `ACCESS_ROLES6`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_7` <- `ACCESS_ROLES7`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_8` <- `ACCESS_ROLES8`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_9` <- `ACCESS_ROLES9`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_10` <- `ACCESS_ROLES10`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_11` <- `ACCESS_ROLES11`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_12` <- `ACCESS_ROLES12`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_13` <- `ACCESS_ROLES13`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_14` <- `ACCESS_ROLES14`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_15` <- `ACCESS_ROLES15`,
    `cv_r_invoice_permutation_all`.`ACCESS_ROLES_17` <- `ACCESS_ROLES17`,
    `cv_r_invoice_permutation_all`.`PRODUCT_ATTR_ACCESS_ROLES` <- `product_attr_access_roles_1`,
    `cv_r_invoice_permutation_all`.`STORE_ATTR_ACCESS_ROLES` <- `store_attr_access_roles_1`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_period_value_bins_dim
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_period_value_bins_dim`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_period_value_bins_dim/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_period_value_bins_dim`
FORMAT Parquet
(
    `cv_r_period_value_bins_dim`.`internal_id` <- `internal_id`,
    `cv_r_period_value_bins_dim`.`rank` <- `rank`,
    `cv_r_period_value_bins_dim`.`bin_description` <- `bin_description`,
    `cv_r_period_value_bins_dim`.`from_val` <- `from_val`,
    `cv_r_period_value_bins_dim`.`to_val` <- `to_val`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_product_attribute_relation
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_product_attribute_relation`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_product_attribute_relation/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_product_attribute_relation`
FORMAT Parquet
(
    `cv_r_product_attribute_relation`.`internal_id` <- `internal_id`,
    `cv_r_product_attribute_relation`.`attribute_id` <- `attribute_id`,
    `cv_r_product_attribute_relation`.`attribute_value_id` <- `attribute_value_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_purchase_order
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_purchase_order`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_sc_purchase_order/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_purchase_order_all`
FORMAT Parquet
(
    `cv_r_purchase_order_all`.`purchase_order_number` <- `PURCHASE_ORDER_NUMBER`,
    `cv_r_purchase_order_all`.`purchase_order_line_number` <- `PURCHASE_ORDER_LINE_NUMBER`,
    `cv_r_purchase_order_all`.`location_type` <- `LOCATION_TYPE`,
    `cv_r_purchase_order_all`.`cv_pos_id` <- `CV_POS_ID`,
    `cv_r_purchase_order_all`.`dc_internal_id` <- `DC_INTERNAL_ID`,
    `cv_r_purchase_order_all`.`cv_vendor_id` <- `CV_VENDOR_ID`,
    `cv_r_purchase_order_all`.`catalog_internal_id` <- `CATALOG_INTERNAL_ID`,
    `cv_r_purchase_order_all`.`upc` <- `UPC`,
    @V1 <- `ORDER_DATE`,
    @W1 <- `ORDER_TMSP`,
    @V2 <- `EXPECTED_DELIVERY_DATE`,
    @V3 <- `ACTUAL_DELIVERY_DATE`,
    @W2 <- `ACTUAL_DELIVERY_TMSP`,
    `cv_r_purchase_order_all`.`delay_days` <- `DELAY_DAYS`,
    `cv_r_purchase_order_all`.`purchase_order_type_code` <- `PURCHASE_ORDER_TYPE_CODE`,
    `cv_r_purchase_order_all`.`purchase_order_type_description` <- `PURCHASE_ORDER_TYPE_DESCRIPTION`,
    `cv_r_purchase_order_all`.`purchase_order_status_code` <- `PURCHASE_ORDER_STATUS_CODE`,
    `cv_r_purchase_order_all`.`purchase_order_status_description` <- `PURCHASE_ORDER_STATUS_DESCRIPTION`,
    `cv_r_purchase_order_all`.`purchase_order_line_status_code` <- `PURCHASE_ORDER_LINE_STATUS_CODE`,
    `cv_r_purchase_order_all`.`purchase_order_line_status_description` <- `PURCHASE_ORDER_LINE_STATUS_DESCRIPTION`,
    `cv_r_purchase_order_all`.`purchase_order_line_requested_quantity` <- `PURCHASE_ORDER_LINE_REQUESTED_QUANTITY`,
    `cv_r_purchase_order_all`.`purchase_order_line_requested_amount` <- `PURCHASE_ORDER_LINE_REQUESTED_AMOUNT`,
    `cv_r_purchase_order_all`.`purchase_order_line_received_quantity` <- `PURCHASE_ORDER_LINE_RECEIVED_QUANTITY`,
    `cv_r_purchase_order_all`.`purchase_order_line_received_amount` <- `PURCHASE_ORDER_LINE_RECEIVED_AMOUNT`,
    @B1 <- `PURCHASE_ORDER_ON_TIME_IN_FULL_FLAG`,
    `cv_r_purchase_order_all`.`pack_multiplier` <- `PACK_MULTIPLIER`,
    `cv_r_purchase_order_all`.`purchase_order_line_otif_percent` <- `PURCHASE_ORDER_LINE_OTIF_PERCENT`,
    `cv_r_purchase_order_all`.`purchase_order_line_on_time_percent` <- `PURCHASE_ORDER_LINE_ON_TIME_PERCENT`,
    `cv_r_purchase_order_all`.`purchase_order_line_in_full_percent` <- `PURCHASE_ORDER_LINE_IN_FULL_PERCENT`,
    `cv_r_purchase_order_all`.`order_vendor_pack_quantity_to_use` <- `ORDER_VENDOR_PACK_QUANTITY_TO_USE`,
    `cv_r_purchase_order_all`.`on_time_vendor_pack_quantity` <- `ON_TIME_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`late_vendor_pack_quantity` <- `LATE_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`early_vendor_pack_quantity` <- `EARLY_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`late_percent` <- `LATE_PERCENT`,
    `cv_r_purchase_order_all`.`early_percent` <- `EARLY_PERCENT`,
    `cv_r_purchase_order_all`.`order_vendor_pack_quantity` <- `ORDER_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`receive_vendor_pack_quantity_to_use` <- `RECEIVE_VENDOR_PACK_QUANTITY_TO_USE`,
    `cv_r_purchase_order_all`.`on_time_charges` <- `ON_TIME_CHARGES`,
    `cv_r_purchase_order_all`.`on_time_non_compliant_quantity` <- `ON_TIME_NON_COMPLIANT_QUANTITY`,
    `cv_r_purchase_order_all`.`on_time_receive_vendor_pack_quantity` <- `ON_TIME_RECEIVE_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`vendor_owned_cost_of_goods` <- `VENDOR_OWNED_COST_OF_GOODS`,
    `cv_r_purchase_order_all`.`retailer_owned_cost_of_goods` <- `RETAILER_OWNED_COST_OF_GOODS`,
    `cv_r_purchase_order_all`.`cancel_system_purchase_order_vendor_pack_quantity` <- `CANCEL_SYSTEM_PURCHASE_ORDER_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`damaged_vendor_pack_quantity` <- `DAMAGED_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`carrier_name` <- `CARRIER_NAME`,
    `cv_r_purchase_order_all`.`total_vendor_pack_cost_amount` <- `TOTAL_VENDOR_PACK_COST_AMOUNT`,
    `cv_r_purchase_order_all`.`unfilled_vendor_pack_quantity` <- `UNFILLED_VENDOR_PACK_QUANTITY`,
    @V4 <- `MUST_ARRIVE_DATE_TO_USE`,
    @W3 <- `APPOINTMENT_CREATE_TMSP`,
    `cv_r_purchase_order_all`.`cancel_reason_code` <- `CANCEL_REASON_CODE`,
    `cv_r_purchase_order_all`.`cancel_indicator` <- `CANCEL_INDICATOR`,
    @V5 <- `DC_APPOINTMENT_DATE`,
    @W4 <- `LOCAL_ARRIVAL_TIME`,
    @V6 <- `REFERENCE_DATE`,
    @W5 <- `REFERENCE_TIME`,
    `cv_r_purchase_order_all`.`total_vendor_owned_vendor_pack_quantity` <- `TOTAL_VENDOR_OWNED_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`total_retailer_owned_vendor_pack_quantity` <- `TOTAL_RETAILER_OWNED_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`overfilled_vendor_pack_quantity` <- `OVERFILLED_VENDOR_PACK_QUANTITY`,
    `cv_r_purchase_order_all`.`invoice_amount` <- `INVOICE_AMOUNT`,
    `cv_r_purchase_order_all`.`final_charges` <- `FINAL_CHARGES`,
    `cv_r_purchase_order_all`.`in_full_charges` <- `IN_FULL_CHARGES`,
    `cv_r_purchase_order_all`.`rec_insert_tmsp` <- `REC_INSERT_TMSP`,
    @V7 <- `PURCHASE_ORDER_DO_NOT_SHIP_BEFORE_DATE`,
    @V8 <- `PURCHASE_ORDER_CLOSE_DATE`,
    @V9 <- `PURCHASE_ORDER_CREATE_DATE`,
    `cv_r_purchase_order_all`.`attribute_c_1` <- `attribute_c_1`,
    `cv_r_purchase_order_all`.`attribute_c_2` <- `attribute_c_2`,
    `cv_r_purchase_order_all`.`attribute_c_3` <- `attribute_c_3`,
    `cv_r_purchase_order_all`.`attribute_c_4` <- `attribute_c_4`,
    `cv_r_purchase_order_all`.`attribute_c_5` <- `attribute_c_5`,
    `cv_r_purchase_order_all`.`attribute_c_6` <- `attribute_c_6`,
    `cv_r_purchase_order_all`.`attribute_c_7` <- `attribute_c_7`,
    `cv_r_purchase_order_all`.`attribute_c_8` <- `attribute_c_8`,
    `cv_r_purchase_order_all`.`attribute_c_9` <- `attribute_c_9`,
    `cv_r_purchase_order_all`.`attribute_c_10` <- `attribute_c_10`,
    `cv_r_purchase_order_all`.`attribute_c_11` <- `attribute_c_11`,
    `cv_r_purchase_order_all`.`attribute_c_12` <- `attribute_c_12`,
    `cv_r_purchase_order_all`.`attribute_c_13` <- `attribute_c_13`,
    `cv_r_purchase_order_all`.`attribute_c_14` <- `attribute_c_14`,
    `cv_r_purchase_order_all`.`attribute_c_15` <- `attribute_c_15`,
    `cv_r_purchase_order_all`.`attribute_c_16` <- `attribute_c_16`,
    `cv_r_purchase_order_all`.`attribute_c_17` <- `attribute_c_17`,
    `cv_r_purchase_order_all`.`attribute_c_18` <- `attribute_c_18`,
    `cv_r_purchase_order_all`.`attribute_c_19` <- `attribute_c_19`,
    `cv_r_purchase_order_all`.`attribute_c_20` <- `attribute_c_20`,
    `cv_r_purchase_order_all`.`attribute_c_21` <- `attribute_c_21`,
    `cv_r_purchase_order_all`.`attribute_c_22` <- `attribute_c_22`,
    `cv_r_purchase_order_all`.`attribute_c_23` <- `attribute_c_23`,
    `cv_r_purchase_order_all`.`attribute_c_24` <- `attribute_c_24`,
    `cv_r_purchase_order_all`.`attribute_c_25` <- `attribute_c_25`,
    `cv_r_purchase_order_all`.`attribute_c_26` <- `attribute_c_26`,
    `cv_r_purchase_order_all`.`attribute_c_27` <- `attribute_c_27`,
    `cv_r_purchase_order_all`.`attribute_c_28` <- `attribute_c_28`,
    `cv_r_purchase_order_all`.`attribute_c_29` <- `attribute_c_29`,
    `cv_r_purchase_order_all`.`attribute_c_30` <- `attribute_c_30`,
    `cv_r_purchase_order_all`.`attribute_n_31` <- `attribute_n_31`,
    `cv_r_purchase_order_all`.`attribute_n_32` <- `attribute_n_32`,
    `cv_r_purchase_order_all`.`attribute_n_33` <- `attribute_n_33`,
    `cv_r_purchase_order_all`.`attribute_n_34` <- `attribute_n_34`,
    `cv_r_purchase_order_all`.`attribute_n_35` <- `attribute_n_35`,
    `cv_r_purchase_order_all`.`attribute_n_36` <- `attribute_n_36`,
    `cv_r_purchase_order_all`.`attribute_n_37` <- `attribute_n_37`,
    `cv_r_purchase_order_all`.`attribute_n_38` <- `attribute_n_38`,
    `cv_r_purchase_order_all`.`attribute_n_39` <- `attribute_n_39`,
    `cv_r_purchase_order_all`.`attribute_n_40` <- `attribute_n_40`,
    `cv_r_purchase_order_all`.`attribute_n_41` <- `attribute_n_41`,
    `cv_r_purchase_order_all`.`attribute_n_42` <- `attribute_n_42`,
    `cv_r_purchase_order_all`.`attribute_n_43` <- `attribute_n_43`,
    `cv_r_purchase_order_all`.`attribute_n_44` <- `attribute_n_44`,
    `cv_r_purchase_order_all`.`attribute_n_45` <- `attribute_n_45`,
    `cv_r_purchase_order_all`.`attribute_n_46` <- `attribute_n_46`,
    `cv_r_purchase_order_all`.`attribute_n_47` <- `attribute_n_47`,
    `cv_r_purchase_order_all`.`attribute_n_48` <- `attribute_n_48`,
    `cv_r_purchase_order_all`.`attribute_n_49` <- `attribute_n_49`,
    `cv_r_purchase_order_all`.`attribute_n_50` <- `attribute_n_50`,
    `cv_r_purchase_order_all`.`attribute_n_51` <- `attribute_n_51`,
    `cv_r_purchase_order_all`.`attribute_n_52` <- `attribute_n_52`,
    `cv_r_purchase_order_all`.`attribute_n_53` <- `attribute_n_53`,
    `cv_r_purchase_order_all`.`attribute_n_54` <- `attribute_n_54`,
    `cv_r_purchase_order_all`.`attribute_n_55` <- `attribute_n_55`,
    `cv_r_purchase_order_all`.`attribute_n_56` <- `attribute_n_56`,
    `cv_r_purchase_order_all`.`attribute_n_57` <- `attribute_n_57`,
    `cv_r_purchase_order_all`.`attribute_n_58` <- `attribute_n_58`,
    `cv_r_purchase_order_all`.`attribute_n_59` <- `attribute_n_59`,
    `cv_r_purchase_order_all`.`attribute_n_60` <- `attribute_n_60`
)
SET
    `order_date` = DATE_ADD('1970-01-01', INTERVAL @V1 DAY),
    `expected_delivery_date` = DATE_ADD('1970-01-01', INTERVAL @V2 DAY),
    `actual_delivery_date` = DATE_ADD('1970-01-01', INTERVAL @V3 DAY),
    `must_arrive_date_to_use` = DATE_ADD('1970-01-01', INTERVAL @V4 DAY),
    `dc_appointment_date` = DATE_ADD('1970-01-01', INTERVAL @V5 DAY),
    `reference_date` = DATE_ADD('1970-01-01', INTERVAL @V6 DAY),
    `purchase_order_do_not_ship_before_date` = DATE_ADD('1970-01-01', INTERVAL @V7 DAY),
    `purchase_order_close_date` = DATE_ADD('1970-01-01', INTERVAL @V8 DAY),
    `purchase_order_create_date` = DATE_ADD('1970-01-01', INTERVAL @V9 DAY),
    `order_tmsp` = cast(@W1 as datetime),
    `actual_delivery_tmsp` = cast(@W2 as datetime),
    `appointment_create_timestamp` = cast(@W3 as datetime),
    `local_arrival_time` = cast(@W4 as datetime),
    `reference_time` = cast(@W5 as datetime),
    `purchase_order_on_time_in_full_flag` = case when @B1 = True then 'true' when @B1 = False then 'false' else '' end,
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_sc_permutations
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_sc_permutations`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_sc_permutations/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_sc_permutation_all_roles`
FORMAT Parquet
(
    `cv_r_sc_permutation_all_roles`.`hier` <- `hier`,
    `cv_r_sc_permutation_all_roles`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_sc_permutation_all_roles`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_sc_permutation_all_roles`.`dc_internal_id` <- `dc_internal_id`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_1` <- `ACCESS_ROLES1`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_2` <- `ACCESS_ROLES2`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_3` <- `ACCESS_ROLES3`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_4` <- `ACCESS_ROLES4`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_5` <- `ACCESS_ROLES5`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_6` <- `ACCESS_ROLES6`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_7` <- `ACCESS_ROLES7`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_8` <- `ACCESS_ROLES8`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_9` <- `ACCESS_ROLES9`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_10` <- `ACCESS_ROLES10`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_11` <- `ACCESS_ROLES11`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_12` <- `ACCESS_ROLES12`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_13` <- `ACCESS_ROLES13`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_14` <- `ACCESS_ROLES14`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_15` <- `ACCESS_ROLES15`,
    `cv_r_sc_permutation_all_roles`.`PRODUCT_ATTR_ACCESS_ROLES` <- `product_attr_access_roles_1`,
    `cv_r_sc_permutation_all_roles`.`STORE_ATTR_ACCESS_ROLES` <- `store_attr_access_roles_1`,
    `cv_r_sc_permutation_all_roles`.`ACCESS_ROLES_16` <- `ACCESS_ROLES16`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_store_attribute_relation
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_store_attribute_relation`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_store_attribute_relation/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_store_attribute_relation`
FORMAT Parquet
(
    `cv_r_store_attribute_relation`.`internal_id` <- `internal_id`,
    `cv_r_store_attribute_relation`.`attribute_id` <- `attribute_id`,
    `cv_r_store_attribute_relation`.`attribute_value_id` <- `attribute_value_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_product_store_attribute_relation
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_product_store_attribute_relation`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_product_store_attribute_relation/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_product_store_attribute_relation`
FORMAT Parquet
(
    `cv_r_product_store_attribute_relation`.`catalog_internal_id` <- `cv_product_id`,
    `cv_r_product_store_attribute_relation`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_product_store_attribute_relation`.`attribute_id` <- `attribute_id`,
    `cv_r_product_store_attribute_relation`.`attribute_value_id` <- `attribute_value_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_store_parents_flat
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_store_parents_flat`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_store_parents_flat/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_store_parents_flat`
FORMAT Parquet
(
    `cv_r_store_parents_flat`.`cv_pos_id` <- `child_id`,
    `cv_r_store_parents_flat`.`cv_hier_3_level_1` <- `cv_hier_3_level_1`,
    `cv_r_store_parents_flat`.`cv_hier_3_level_2` <- `cv_hier_3_level_2`,
    `cv_r_store_parents_flat`.`cv_hier_3_level_3` <- `cv_hier_3_level_3`,
    `cv_r_store_parents_flat`.`cv_hier_3_level_4` <- `cv_hier_3_level_4`,
    `cv_r_store_parents_flat`.`cv_hier_3_level_5` <- `cv_hier_3_level_5`,
    `cv_r_store_parents_flat`.`cv_hier_5_level_1` <- `cv_hier_5_level_1`,
    `cv_r_store_parents_flat`.`cv_hier_5_level_2` <- `cv_hier_5_level_2`,
    `cv_r_store_parents_flat`.`cv_hier_5_level_3` <- `cv_hier_5_level_3`,
    `cv_r_store_parents_flat`.`cv_hier_5_level_4` <- `cv_hier_5_level_4`,
    `cv_r_store_parents_flat`.`cv_hier_5_level_5` <- `cv_hier_5_level_5`,
    `cv_r_store_parents_flat`.`cv_hier_9_level_1` <- `cv_hier_9_level_1`,
    `cv_r_store_parents_flat`.`cv_hier_9_level_2` <- `cv_hier_9_level_2`,
    `cv_r_store_parents_flat`.`cv_hier_9_level_3` <- `cv_hier_9_level_3`,
    `cv_r_store_parents_flat`.`cv_hier_9_level_4` <- `cv_hier_9_level_4`,
    `cv_r_store_parents_flat`.`cv_hier_9_level_5` <- `cv_hier_9_level_5`,
    `cv_r_store_parents_flat`.`cv_hier_11_level_1` <- `cv_hier_11_level_1`,
    `cv_r_store_parents_flat`.`cv_hier_11_level_2` <- `cv_hier_11_level_2`,
    `cv_r_store_parents_flat`.`cv_hier_11_level_3` <- `cv_hier_11_level_3`,
    `cv_r_store_parents_flat`.`cv_hier_11_level_4` <- `cv_hier_11_level_4`,
    `cv_r_store_parents_flat`.`cv_hier_11_level_5` <- `cv_hier_11_level_5`,
    `cv_r_store_parents_flat`.`cv_hier_17_level_1` <- `cv_hier_17_level_1`,
    `cv_r_store_parents_flat`.`cv_hier_17_level_2` <- `cv_hier_17_level_2`,
    `cv_r_store_parents_flat`.`cv_hier_17_level_3` <- `cv_hier_17_level_3`,
    `cv_r_store_parents_flat`.`cv_hier_17_level_4` <- `cv_hier_17_level_4`,
    `cv_r_store_parents_flat`.`cv_hier_17_level_5` <- `cv_hier_17_level_5`,
    `cv_r_store_parents_flat`.`access_roles_3` <- `access_roles_3`,
    `cv_r_store_parents_flat`.`access_roles_5` <- `access_roles_5`,
    `cv_r_store_parents_flat`.`access_roles_9` <- `access_roles_9`,
    `cv_r_store_parents_flat`.`access_roles_11` <- `access_roles_11`,
    `cv_r_store_parents_flat`.`access_roles_17` <- `access_roles_17`,
    `cv_r_store_parents_flat`.`store_attr_access_roles` <- `attr_access_roles_1`,
    `cv_r_store_parents_flat`.`same_pos` <- `same_pos`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_promo
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_promo`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_promo/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_promo`
FORMAT Parquet
(
    `cv_r_promo`.`promo_id` <- `promo_id`,
    `cv_r_promo`.`promo_external_id` <- `promo_external_id`,
    `cv_r_promo`.`promo_name` <- `promo_name`,
    @promodatefrom <- `promo_date_from`,
    @promodateto <- `promo_date_to`,
    `cv_r_promo`.`attribute_s_1` <- `attribute_s_1`,
    `cv_r_promo`.`attribute_s_2` <- `attribute_s_2`,
    `cv_r_promo`.`attribute_s_3` <- `attribute_s_3`,
    `cv_r_promo`.`attribute_s_4` <- `attribute_s_4`,
    `cv_r_promo`.`attribute_s_5` <- `attribute_s_5`,
    `cv_r_promo`.`attribute_s_6` <- `attribute_s_6`,
    `cv_r_promo`.`attribute_s_7` <- `attribute_s_7`,
    `cv_r_promo`.`attribute_s_8` <- `attribute_s_8`,
    `cv_r_promo`.`attribute_s_9` <- `attribute_s_9`,
    `cv_r_promo`.`attribute_s_10` <- `attribute_s_10`,
    `cv_r_promo`.`attribute_c_1` <- `attribute_c_1`,
    `cv_r_promo`.`attribute_c_2` <- `attribute_c_2`,
    `cv_r_promo`.`attribute_c_3` <- `attribute_c_3`,
    `cv_r_promo`.`attribute_c_4` <- `attribute_c_4`,
    `cv_r_promo`.`attribute_c_5` <- `attribute_c_5`,
    `cv_r_promo`.`attribute_c_6` <- `attribute_c_6`,
    `cv_r_promo`.`attribute_c_7` <- `attribute_c_7`,
    `cv_r_promo`.`attribute_c_8` <- `attribute_c_8`,
    `cv_r_promo`.`attribute_c_9` <- `attribute_c_9`,
    `cv_r_promo`.`attribute_c_10` <- `attribute_c_10`
)
SET
    `promo_date_from` = DATE_ADD('1970-01-01', INTERVAL @promodatefrom DAY),
    `promo_date_to` = DATE_ADD('1970-01-01', INTERVAL @promodateto DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_promo_product
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_promo_product`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_promo_product/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_promo_product_all`
FORMAT Parquet
(
    `cv_r_promo_product_all`.`promo_id` <- `promo_id`,
    `cv_r_promo_product_all`.`catalog_internal_id` <- `catalog_internal_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_promo_store
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_promo_store`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_promo_store/'
BATCH_INTERVAL 2500
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_promo_store_all`
FORMAT Parquet
(
    `cv_r_promo_store_all`.`promo_id` <- `promo_id`,
    `cv_r_promo_store_all`.`cv_pos_id` <- `cv_pos_id`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_events_baseline
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_events_baseline`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_events_baseline/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_events_baseline`
FORMAT Parquet
(
    `cv_r_events_baseline`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_events_baseline`.`catalog_internal_id` <- `catalog_internal_id`,
    @weekfirstdate <- `week_first_date`,
    `cv_r_events_baseline`.`unq_evts` <- `unq_evts`,
    `cv_r_events_baseline`.`base_units` <- `base_units`,
    `cv_r_events_baseline`.`base_sales` <- `base_sales`,
    `cv_r_events_baseline`.`base_sales_local` <- `base_sales_local`,
    `cv_r_events_baseline`.`base_sales_no_tax` <- `base_sales_no_tax`,
    `cv_r_events_baseline`.`base_sales_no_tax_local` <- `base_sales_no_tax_local`,
    `cv_r_events_baseline`.`base_gross_sales` <- `base_gross_sales`,
    `cv_r_events_baseline`.`base_discount` <- `base_discount`,
    `cv_r_events_baseline`.`base_discount_local` <- `base_discount_local`,
    `cv_r_events_baseline`.`base_discount_no_tax` <- `base_discount_no_tax`,
    `cv_r_events_baseline`.`base_discount_no_tax_local` <- `base_discount_no_tax_local`,
    `cv_r_events_baseline`.`base_margin` <- `base_margin`,
    `cv_r_events_baseline`.`base_margin_local` <- `base_margin_local`,
    `cv_r_events_baseline`.`base_uom_qty` <- `base_uom_qty`
)
SET
    `week_first_date` = DATE_ADD('1970-01-01', INTERVAL @weekfirstdate DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_events_baseline_week
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_events_baseline_week`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_events_baseline_week/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_events_baseline_week`
FORMAT Parquet
(
    `cv_r_events_baseline_week`.`promo_id` <- `promo_id`,
    `cv_r_events_baseline_week`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_events_baseline_week`.`cv_pos_id` <- `cv_pos_id`,
    `cv_r_events_baseline_week`.`week_first_date` <- `week_first_date`,
    `cv_r_events_baseline_week`.`bs_week_first_date` <- `bs_week_first_date`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_promo_kpi
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_promo_kpi`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_promo_kpi/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_promo_kpi`
FORMAT Parquet
(
    `cv_r_promo_kpi`.`catalog_internal_id` <- `catalog_internal_id`,
    `cv_r_promo_kpi`.`cv_pos_id` <- `cv_pos_id`,
    @weekfirstdate <- `week_first_date`,
    `cv_r_promo_kpi`.`cannibalization_pct` <- `cannibalization_pct`,
    `cv_r_promo_kpi`.`halo_pct` <- `halo_pct`,
    `cv_r_promo_kpi`.`pullforward_pct` <- `pullforward_pct`
)
SET
    `week_first_date` = DATE_ADD('1970-01-01', INTERVAL @weekfirstdate DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_geo_location
-- ======================================================================
CREATE OR REPLACE AGGREGATOR PIPELINE `cv_r_geo_location`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/col_databricks/cv_r_geo_location/'
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 1
DISABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
SKIP DUPLICATE KEY ERRORS
INTO TABLE `cv_r_geospatial_data`
FORMAT Parquet
(
    `cv_r_geospatial_data`.`hier` <- `hier`,
    `cv_r_geospatial_data`.`child_id` <- `child_id`,
    `cv_r_geospatial_data`.`child_level` <- `child_level`,
    `cv_r_geospatial_data`.`geolocation` <- `geolocation`,
    `cv_r_geospatial_data`.`region` <- `polygon`
)
SET
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_rpt_sku_ranking_all
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_rpt_sku_ranking_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/reports_databricks/cv_r_rpt_sku_ranking_all/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_rpt_sku_ranking_all`
FORMAT Parquet
(
    `cv_r_rpt_sku_ranking_all`.`period_type` <- `PERIOD_TYPE`,
    `cv_r_rpt_sku_ranking_all`.`cv_product_item_id` <- `CV_PRODUCT_ITEM_ID`,
    `cv_r_rpt_sku_ranking_all`.`cv_store_pos_id` <- `STORE_POS_ID`,
    `cv_r_rpt_sku_ranking_all`.`cv_store_pos_level` <- `STORE_POS_LEVEL`,
    `cv_r_rpt_sku_ranking_all`.`cv_store_channel_id` <- `STORE_CHANNEL_ID`,
    `cv_r_rpt_sku_ranking_all`.`cv_store_channel_level` <- `STORE_CHANNEL_LEVEL`,
    `cv_r_rpt_sku_ranking_all`.`total_turnover` <- `TOTAL_TURNOVER`,
    `cv_r_rpt_sku_ranking_all`.`total_turnover_compare` <- `TOTAL_TURNOVER_COMPARE`,
    `cv_r_rpt_sku_ranking_all`.`total_cardholders` <- `TOTAL_ACTIVE_CARDHOLDERS`,
    `cv_r_rpt_sku_ranking_all`.`total_cardholders_only_pos_filter` <- `TOTAL_ACTIVE_CARDHOLDERS_ONLY_POS_FILTER`,
    `cv_r_rpt_sku_ranking_all`.`total_cardholders_compare` <- `TOTAL_ACTIVE_CARDHOLDERS_COMPARE`,
    `cv_r_rpt_sku_ranking_all`.`total_cardholders_compare_only_pos_filter` <- `TOTAL_ACTIVE_CARDHOLDERS_COMPARE_ONLY_POS_FILTER`,
    `cv_r_rpt_sku_ranking_all`.`total_discount` <- `TOTAL_DISCOUNT`,
    `cv_r_rpt_sku_ranking_all`.`total_qty_sales` <- `TOTAL_QUANTITY`,
    `cv_r_rpt_sku_ranking_all`.`total_qty_sales_compare` <- `TOTAL_QUANTITY_COMPARE`,
    `cv_r_rpt_sku_ranking_all`.`discount_qty_sales` <- `DISCOUNT_QUANTITY`,
    `cv_r_rpt_sku_ranking_all`.`discount_turnover` <- `DISCOUNT_TURNOVER`,
    `cv_r_rpt_sku_ranking_all`.`visits` <- `VISITS`,
    `cv_r_rpt_sku_ranking_all`.`visits_only_pos_filter` <- `VISITS_ONLY_POS_FILTER`,
    `cv_r_rpt_sku_ranking_all`.`visits_compare` <- `VISITS_COMPARE`,
    `cv_r_rpt_sku_ranking_all`.`visits_compare_only_pos_filter` <- `VISITS_COMPARE_ONLY_POS_FILTER`,
    `cv_r_rpt_sku_ranking_all`.`unit_sales_velocity` <- `UNIT_SALES_VELOCITY`,
    `cv_r_rpt_sku_ranking_all`.`sales_velocity` <- `SALES_VELOCITY`,
    `cv_r_rpt_sku_ranking_all`.`weighted_distribution` <- `WEIGHTED_DISTRIBUTION`,
    `cv_r_rpt_sku_ranking_all`.`loyalty_index` <- `LOYALTY_INDEX`,
    `cv_r_rpt_sku_ranking_all`.`num_loyal` <- `NUM_LOYAL`,
    `cv_r_rpt_sku_ranking_all`.`retailer_loyal` <- `HIGHLY_COUNT`,
    `cv_r_rpt_sku_ranking_all`.`retailer_loyalty_spend_index` <- `RETAILER_LOYALTY_SPEND_INDEX`,
    `cv_r_rpt_sku_ranking_all`.`weeks_on_shelf` <- `WEEKS_ON_SHELF`,
    `cv_r_rpt_sku_ranking_all`.`store_selling_count` <- `STORES_SELLING_COUNT`,
    @fromdate <- `FROM_DATE`,
    @todate <- `TO_DATE`,
    @comparefromdate <- `COMPARE_FROM_DATE`,
    @comparetodate <- `COMPARE_TO_DATE`
)
SET
    `from_date` = DATE_ADD('1970-01-01', INTERVAL @fromdate DAY),
    `to_date` = DATE_ADD('1970-01-01', INTERVAL @todate DAY),
    `compare_from_date` = DATE_ADD('1970-01-01', INTERVAL @comparefromdate DAY),
    `compare_to_date` = DATE_ADD('1970-01-01', INTERVAL @comparetodate DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_rpt_brand_ranking_all
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_rpt_brand_ranking_all`
AS LOAD DATA LINK storageConnection 'refresh-pick-n-pay-validation-container/data_load/latest/reports_databricks/cv_r_rpt_brand_ranking_all/'
BATCH_INTERVAL 2500
ENABLE OUT_OF_ORDER OPTIMIZATION
DISABLE OFFSETS METADATA GC
INTO TABLE `cv_r_rpt_brand_ranking_all`
FORMAT Parquet
(
    `cv_r_rpt_brand_ranking_all`.`period_type` <- `PERIOD_TYPE`,
    `cv_r_rpt_brand_ranking_all`.`cv_brand_id` <- `CV_BRAND_ID`,
    `cv_r_rpt_brand_ranking_all`.`cv_section_id` <- `CV_SECTION_ID`,
    `cv_r_rpt_brand_ranking_all`.`cv_store_pos_id` <- `STORE_POS_ID`,
    `cv_r_rpt_brand_ranking_all`.`cv_store_pos_level` <- `STORE_POS_LEVEL`,
    `cv_r_rpt_brand_ranking_all`.`cv_store_channel_id` <- `STORE_CHANNEL_ID`,
    `cv_r_rpt_brand_ranking_all`.`cv_store_channel_level` <- `STORE_CHANNEL_LEVEL`,
    `cv_r_rpt_brand_ranking_all`.`total_turnover` <- `TOTAL_TURNOVER`,
    `cv_r_rpt_brand_ranking_all`.`total_turnover_compare` <- `TOTAL_TURNOVER_COMPARE`,
    `cv_r_rpt_brand_ranking_all`.`total_cardholders` <- `TOTAL_ACTIVE_CARDHOLDERS`,
    `cv_r_rpt_brand_ranking_all`.`total_cardholders_only_pos_filter` <- `TOTAL_ACTIVE_CARDHOLDERS_ONLY_POS_FILTER`,
    `cv_r_rpt_brand_ranking_all`.`total_cardholders_compare` <- `TOTAL_ACTIVE_CARDHOLDERS_COMPARE`,
    `cv_r_rpt_brand_ranking_all`.`total_cardholders_compare_only_pos_filter` <- `TOTAL_ACTIVE_CARDHOLDERS_COMPARE_ONLY_POS_FILTER`,
    `cv_r_rpt_brand_ranking_all`.`total_discount` <- `TOTAL_DISCOUNT`,
    `cv_r_rpt_brand_ranking_all`.`total_qty_sales` <- `TOTAL_QUANTITY`,
    `cv_r_rpt_brand_ranking_all`.`total_qty_sales_compare` <- `TOTAL_QUANTITY_COMPARE`,
    `cv_r_rpt_brand_ranking_all`.`discount_qty_sales` <- `DISCOUNT_QUANTITY`,
    `cv_r_rpt_brand_ranking_all`.`discount_turnover` <- `DISCOUNT_TURNOVER`,
    `cv_r_rpt_brand_ranking_all`.`visits` <- `VISITS`,
    `cv_r_rpt_brand_ranking_all`.`visits_only_pos_filter` <- `VISITS_ONLY_POS_FILTER`,
    `cv_r_rpt_brand_ranking_all`.`visits_compare` <- `VISITS_COMPARE`,
    `cv_r_rpt_brand_ranking_all`.`visits_compare_only_pos_filter` <- `VISITS_COMPARE_ONLY_POS_FILTER`,
    `cv_r_rpt_brand_ranking_all`.`unit_sales_velocity` <- `UNIT_SALES_VELOCITY`,
    `cv_r_rpt_brand_ranking_all`.`sales_velocity` <- `SALES_VELOCITY`,
    `cv_r_rpt_brand_ranking_all`.`weighted_distribution` <- `WEIGHTED_DISTRIBUTION`,
    `cv_r_rpt_brand_ranking_all`.`loyalty_index` <- `BRAND_LOYALTY_INDEX`,
    `cv_r_rpt_brand_ranking_all`.`num_loyal` <- `NUM_LOYAL`,
    `cv_r_rpt_brand_ranking_all`.`num_switchers` <- `BRAND_SWITCHERS`,
    `cv_r_rpt_brand_ranking_all`.`num_explorers` <- `BRAND_EXPLORERS`,
    `cv_r_rpt_brand_ranking_all`.`num_churning` <- `BRAND_CHURNING`,
    `cv_r_rpt_brand_ranking_all`.`num_xsell` <- `NUM_XSELL`,
    `cv_r_rpt_brand_ranking_all`.`retailer_loyal` <- `HIGHLY_COUNT`,
    `cv_r_rpt_brand_ranking_all`.`retailer_loyalty_spend_index` <- `RETAILER_LOYALTY_SPEND_INDEX`,
    `cv_r_rpt_brand_ranking_all`.`weeks_on_shelf` <- `WEEKS_ON_SHELF`,
    `cv_r_rpt_brand_ranking_all`.`store_selling_count` <- `STORES_SELLING_COUNT`,
    @fromdate <- `FROM_DATE`,
    @todate <- `TO_DATE`,
    @comparefromdate <- `COMPARE_FROM_DATE`,
    @comparetodate <- `COMPARE_TO_DATE`
)
SET
    `from_date` = DATE_ADD('1970-01-01', INTERVAL @fromdate DAY),
    `to_date` = DATE_ADD('1970-01-01', INTERVAL @todate DAY),
    `compare_from_date` = DATE_ADD('1970-01-01', INTERVAL @comparefromdate DAY),
    `compare_to_date` = DATE_ADD('1970-01-01', INTERVAL @comparetodate DAY),
    `retailer_id` = 6200;

-- ======================================================================
-- Pipeline: cv_r_purchase_history_all
-- ======================================================================
CREATE OR REPLACE PIPELINE `cv_r_purchase_history_all`
AS LOAD DATA AZURE 'data-container/data/6200/output/data_load/col/json.gzip/cv_r_purchase_history/'
CONFIG '{\"suffixes\": [\"json.gz\"]}'
CREDENTIALS <CREDENTIALS REDACTED>
BATCH_INTERVAL 2500
MAX_PARTITIONS_PER_BATCH 28
DISABLE OFFSETS METADATA GC
INTO PROCEDURE `cv_r_purchase_history_upsert`
FIELDS TERMINATED BY '\t' ENCLOSED BY '' ESCAPED BY '\\'
LINES TERMINATED BY '\n' STARTING BY '';

