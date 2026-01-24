use pak_ecommerce;
select * from `pakistan largest ecommerce dataset`;

#Data Cleaning
create table cleaned_ecommerce
like `pakistan largest ecommerce dataset` ;

insert cleaned_ecommerce
select * from `pakistan largest ecommerce dataset`;

#Dropped unnecessary columns
alter table cleaned_ecommerce
drop column MyUnknownColumn,
drop column `MyUnknownColumn_[0]`,
drop column `MyUnknownColumn_[1]`,
drop column `MyUnknownColumn_[2]`,
drop column `MyUnknownColumn_[3]`;

alter table cleaned_ecommerce 
DROP COLUMN `Working Date`,
DROP COLUMN FY, 
DROP COLUMN `M-Y`,
DROP COLUMN `Year`,
DROP COLUMN `Month`,
DROP COLUMN `Customer Since`;

#CTEs to find duplicates
with duplicate_cte as (
select * , row_number() 
over(partition by created_at,sku,`Customer ID`) as row_num 
from cleaned_ecommerce
 order by created_at) 
 select * from duplicate_cte 
   where row_num > 1 ;
   
   #delete duplicates
with duplicate_cte as (
select item_id , row_number() 
over(partition by increment_id,grand_total,sku 
order by item_id) as row_num 
from cleaned_ecommerce 
 where `status`='canceled'  
) delete from duplicate_cte where row_num >1 ;

select * from cleaned_ecommerce 
where `Customer ID`=9011 
order by grand_total;

#deleted wrong grand_total calculations
UPDATE cleaned_ecommerce 
SET grand_total = (price * qty_ordered)-discount_amount
WHERE grand_total != (price * qty_ordered)-discount_amount;

select * from cleaned_ecommerce 
where `status`='canceled' 
order by created_at,grand_total,`Customer ID`;

#deleted unneccesary rows
delete from cleaned_ecommerce 
where grand_total=0;
delete from cleaned_ecommerce
 where `status`='canceled' and grand_total <=10;

delete FROM cleaned_ecommerce 
WHERE sku LIKE 'test%' ;

DELETE FROM cleaned_ecommerce
WHERE item_id IN (
SELECT item_id
FROM (
SELECT item_id,
  ROW_NUMBER() OVER (
  PARTITION BY increment_id, sku, price, qty_ordered
 ORDER BY item_id ) AS row_num
FROM cleaned_ecommerce
 WHERE status = 'canceled'
    ) t
WHERE row_num > 1
);

SELECT *  from cleaned_ecommerce 
where category_name_1 = '\\N' or
`BI Status` = '#REF!';

UPDATE cleaned_ecommerce 
SET `BI Status` = 'Unknown' 
WHERE `BI Status` = '#REF!';

UPDATE cleaned_ecommerce 
SET category_name_1 = 'Unknown' 
WHERE category_name_1 = '\\N';

#Detecting Nulls
SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN category_name_1 IS NULL THEN 1 ELSE 0 END) AS category_nulls,
    SUM(CASE WHEN sku IS NULL THEN 1 ELSE 0 END) AS sku_nulls,
    SUM(CASE WHEN grand_total IS NULL THEN 1 ELSE 0 END) AS total_nulls,
    SUM(CASE WHEN status IS NULL THEN 1 ELSE 0 END) AS status_nulls,
     SUM(CASE WHEN created_at IS NULL THEN 1 ELSE 0 END) AS date_nulls,
      SUM(CASE WHEN `BI Status` IS NULL THEN 1 ELSE 0 END) AS bi_nulls
FROM cleaned_ecommerce;

select distinct payment_method
from cleaned_ecommerce;

#adding whitespaces
UPDATE cleaned_ecommerce
SET payment_method = CASE 
    WHEN payment_method = 'cod' THEN 'Cash on Delivery'
    WHEN payment_method = 'ublcreditcard' THEN 'UBL Credit Card'
    WHEN payment_method = 'mygateway' THEN 'My Gateway'
    WHEN payment_method = 'customercredit' THEN 'Customer Credit'
    WHEN payment_method = 'cashatdoorstep' THEN 'Cash at Doorstep'
    WHEN payment_method = 'mcblite' THEN 'MCB Lite'
    WHEN payment_method = 'internetbanking' THEN 'Internet Banking'
    WHEN payment_method = 'marketingexpense' THEN 'Marketing Expense'
    WHEN payment_method = 'productcredit' THEN 'Product Credit'
     WHEN payment_method = 'financesettlement' THEN 'Finance Settlement'
      WHEN payment_method = 'jazzvoucher' THEN 'Jazz Voucher'
       WHEN payment_method = 'jazzwallet' THEN 'Jazz Wallet'
    ELSE payment_method 
END;

#standardizing the data
select created_at
from cleaned_ecommerce;

update cleaned_ecommerce
set created_at = str_to_date(created_at,'%m/%d/%Y');
alter table cleaned_ecommerce 
modify column created_at date;

select * from cleaned_ecommerce;
