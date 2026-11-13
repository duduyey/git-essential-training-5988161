
/*Import Jassen targeting information
*/

select count(*),count(distinct External_ID) from Janssen_target_2026Q3;
--6148	5211
--5967	5033
--5717	4882
--7006	5631
--5933	4562
--5946	4590

delete from MCM_targeting_ref
where client_name = 'Johnson & Johnson'

insert into MCM_targeting_ref
select '2026Q3' as version,
'Johnson & Johnson' as client_name,
External_ID as Onekey_id,
Products,
TC,
NULL as TC2,
NULL as therapeutic_area
from Janssen_target_2026Q3;

select count(*),count(distinct Onekey_id) from MCM_targeting_ref
where client_name = 'Johnson & Johnson';
--5946	4590


/*Janssen MCM emails 2026Q3
*/
select count(*),count(distinct onekey_id) from Janssen_email_2026Q3;
--2427	1139 2024Q3
--1812	1058 2024Q4
--3081	1744 2025Q1
--6218	2079 2025Q2
--5810	2082 2025Q3
--6760	2806 2025Q4
--5866	2065 2026Q1
--6695	2375 2026Q2
--7858	1971 2026Q3

drop table Janssen_email_2026Q3_1
select onekey_id as onekeyid,
channel as initial_call_type,
'' as initial_call_type2,
call_date as inital_call_date,
--dbo.F_date_02(REPLACE(Call_Date, '/0', '/')) as call_date_new,
convert(nvarchar(50),convert(date,Call_Date)) as call_date_new,
'Janssen-Cilag B.V.' as client_name,
'EMAIL' as call_type_new,
'2026Q3_Janssen_email' as version,
Product as products,
' ' as tier,
Commercial_Medical,
case when Opened_Y_N = 'Y' then '1' else '0' end as open_status,
case when Clicked_Y_N = 'Y' then '1' else '0' end as click_status,
'' as rep
into Janssen_email_2026Q3_1
from Janssen_email_2026Q3

select count(*),count(distinct onekeyid) from Janssen_email_2026Q3_1;
--6760	2806
--5866	2065
--6695	2375
--7858	1971

select distinct Commercial_Medical from Janssen_email_2026Q3_1

update Janssen_email_2026Q3_1
set Commercial_Medical = 'Commercial'
where Commercial_Medical = 'Promotional'

select distinct inital_call_date,call_date_new from Janssen_email_2026Q3_1
order by 2

select distinct open_status,click_status from Janssen_email_2026Q3_1

select count(*),count(distinct onekeyid) from mcm_total
where version = '2026Q3_Janssen_email';
--0	0

insert into mcm_total
select *  from Janssen_email_2026Q3_1 b
where not exists(select 1 from mcm_total a
where a.onekeyid = b.onekeyid
and a.Call_type_new = b.Call_type_new
and a.call_date_new = b.call_date_new
and a.client_name = b.client_name
and isnull(a.products,'1') = isnull(b.products,'1'));


select count(*),count(distinct onekeyid) from mcm_total
where version = '2026Q3_Janssen_email';
--6760	2806
--5866	2065
--6695	2375
--7858	1971 --2026Q3




/*Janssen 2026Q3
*/

select count(*),count(distinct onekey_id) from Janssen_2026Q3
--5498	2291 2026Q1
--5654	2424 2026Q2
--4080	1950 2026Q3

select  Commercial_Medical,count(*) from Janssen_2026Q3
group by Commercial_Medical

update Janssen_2026Q3
set Commercial_Medical = 'Medical'
where Commercial_Medical = 'Medical Call'

update Janssen_2026Q3
set Commercial_Medical = 'Commercial'
where Commercial_Medical = 'Promotional Call'

update Janssen_2026Q3
set Commercial_Medical = 'Others'
where Commercial_Medical = 'Remote Group Call'


drop table Janssen_2026Q3_1;
select onekey_id as onekeyid,
channel as initial_call_type,
call_type as initial_call_type2,
call_date as initial_call_date,
convert(nvarchar(50),convert(date,call_date)) as call_date_new,
'Janssen-Cilag B.V.' as client_name,
case when channel = 'Remote Detailing' then 'Remote Detail'
     when channel = 'Phone' then 'PHONE'
	 when channel in ('F2F','Face to face') then 'F2F'
	 when channel = 'Traditional Mail' then 'POST'
	 when channel = 'Webcall' then 'do not use'
	 when channel = 'Email' then 'Email'
	 end as call_type_new,
'2026Q3_Janssen' as version,
Detailed_Products as products,
' ' as tier,
Commercial_Medical,
'' as open_status,
'' as click_status,
'' as Rep
into Janssen_2026Q3_1
from Janssen_2026Q3;


select count(*),count(distinct onekeyid) from Janssen_2026Q3_1;
--5285	2429 2025Q3
--5630	2504 2025Q4
--5498	2291 2026Q1
--5654	2424 2026Q2
--4080	1950 2026Q3


select distinct initial_call_type,call_type_new from Janssen_2026Q3_1
order by 1;

select distinct initial_call_date,call_date_new from Janssen_2026Q3_1
order by 1;

select distinct Commercial_Medical from Janssen_2026Q3_1

select count(*),count(distinct onekeyid) from mcm_total
where version = '2026Q3_Janssen';


insert into mcm_total
select *  from Janssen_2026Q3_1 b
where not exists(select 1 from mcm_total a
where a.onekeyid = b.onekeyid
and a.Call_type_new = b.Call_type_new
and a.call_date_new = b.call_date_new
and a.client_name = b.client_name
and isnull(a.products,'1') = isnull(b.products,'1'));

select count(*),count(distinct onekeyid) from mcm_total
where version = '2026Q3_Janssen';
--5490	2291 2026Q1
--5654	2424 2026Q2
--4079	1950 2026Q3


/*Create the Janssen option 2 tables*/

select   distinct Detailed_Products from Janssen_2026Q3
order by 1 desc

update Janssen_2026Q3
set Detailed_Products = replace(Detailed_Products,',',';')

drop table Janssen_2026Q3_option2_1;
select Onekey_Id,Channel,Call_Type,Call_Date,Specialty_1,Commercial_Medical,
dbo.F_str_split(Detailed_Products,';',1) as Detailed_Products
into Janssen_2026Q3_option2_1
from Janssen_2026Q3

union all

select Onekey_Id,Channel,Call_Type,Call_Date,Specialty_1,Commercial_Medical,
dbo.F_str_split(Detailed_Products,';',2) as Detailed_Products
from Janssen_2026Q3
where dbo.F_str_split(Detailed_Products,';',2) is not null

union all

select Onekey_Id,Channel,Call_Type,Call_Date,Specialty_1,Commercial_Medical,
dbo.F_str_split(Detailed_Products,';',3) as Detailed_Products 
from Janssen_2026Q3
where dbo.F_str_split(Detailed_Products,';',3) is not null

union all

select Onekey_Id,Channel,Call_Type,Call_Date,Specialty_1,Commercial_Medical,
dbo.F_str_split(Detailed_Products,';',4) as Detailed_Products 
from Janssen_2026Q3
where dbo.F_str_split(Detailed_Products,';',4) is not null

select distinct Detailed_Products from Janssen_2026Q3_option2_1

update Janssen_2026Q3_option2_1
set Detailed_Products = 'No Product'
where Detailed_Products = '0'

select count(*),count(distinct onekey_id) from Janssen_2026Q3_option2_1
--5909	2291 2026Q1
--6046	2424 2026Q2
--4439	1950 2026Q3



drop table Janssen_2026Q3_option2_2;
select onekey_id as onekeyid,
channel as initial_call_type,
call_type as initial_call_type2,
call_date as initial_call_date,
convert(nvarchar(50),convert(date,call_date)) as call_date_new,
'Janssen-Cilag B.V.' as client_name,
case when channel = 'Remote Detailing' then 'Remote Detail'
     when channel = 'Phone' then 'PHONE'
	 when channel in ('F2F','Face to face') then 'F2F'
	 when channel = 'Traditional Mail' then 'POST'
	 when channel = 'Webcall' then 'do not use'
	 when channel = 'Email' then 'Email'
	 end as call_type_new,
'2026Q3_Janssen' as version,
Detailed_Products as products,
' ' as tier,
Commercial_Medical,
'' as open_status,
'' as click_status,
'' as Rep
into Janssen_2026Q3_option2_2
from Janssen_2026Q3_option2_1;


select count(*),count(distinct onekeyid) from Janssen_2026Q3_option2_2
--5909	2291 2026Q1
--6046	2424 2026Q2
--4439	1950 2026Q3

select distinct initial_call_type,call_type_new from Janssen_2026Q3_option2_2
order by 1;

select distinct Commercial_Medical from Janssen_2026Q3_option2_2

select distinct initial_call_date,call_date_new from Janssen_2026Q3_option2_2
order by 1



/******************

QC

*******************/

/*Make sure all the data from latest quarter is loaded*/
select version,count(*) from MCM_Total
where version like '%2026Q3%'
group by version



select distinct len(Call_Date_New) from MCM_Total;
--10

select distinct substring(Call_Date_New,1,4) from MCM_Total
order by 1;

select distinct substring(Call_Date_New,6,2) from MCM_Total
order by 1;

select distinct substring(Call_Date_New,9,2) from MCM_Total
order by 1;



/*Should have 7 different values*/
select distinct call_type_new from MCM_Total
order by 1;

select distinct Commercial_Call_Medical_Call from mcm_total;


select Commercial_Call_Medical_Call,count(*) from MCM_total
where substring(call_date_new,1,4) in ('2022','2023','2024','2025','2026')
and call_type_new in ('F2F','PHONE','Remote detail','POST','EMAIL')
group by Commercial_Call_Medical_Call
order by 1



update MCM_total
set Commercial_Call_Medical_Call = 'Others'
where Commercial_Call_Medical_Call = 'Other'

update MCM_total
set Commercial_Call_Medical_Call = 'Others'
where Commercial_Call_Medical_Call = 'NULL' or Commercial_Call_Medical_Call is null or Commercial_Call_Medical_Call = ' '

update MCM_total
set Commercial_Call_Medical_Call = 'Medical'
where Commercial_Call_Medical_Call = 'Medical Call'

update MCM_Total
set Commercial_Call_Medical_Call = 'Commercial'
where version like '%mailing%'




/*Update open and click status*/
select distinct Email_Opened,Email_Clicked from MCM_total;

update MCM_total
set Email_Opened = '0'
where Email_Opened = 'N' or Email_Opened='NO';

update MCM_total
set Email_Opened = '1'
where Email_Opened = 'Y' or Email_Opened='YES' or Email_Opened='Delivered' or Email_Opened>1;

update MCM_total
set Email_Clicked = '0'
where Email_Clicked = 'N' or Email_Clicked = 'NO';

update MCM_total
set Email_Clicked = '1'
where Email_Clicked = 'Y' or Email_Clicked = 'YES' or Email_Clicked>1;


update MCM_total
set Email_Clicked = NULL
where Email_Clicked=' ';

update MCM_total
set Email_Opened = NULL
where Email_Opened=' ';

--should only have 9 difference combinations
select distinct Email_Opened,Email_Clicked from MCM_total;


select distinct call_type_new,Email_Clicked from MCM_total
where Email_Clicked is not null and Email_Clicked!=' ' and call_type_new not in ('do not use');

select version,count(*) from MCM_total
where Email_Opened = '0' and Email_Clicked = '1'
group by version


drop table specialty_bridge;
select distinct OnekeyID,
specialty as spec1,
specialty_code as Spec1Cod,
specialty2 as spec2,
specialty3 as spec3 into specialty_bridge from  cet
where rown=1;

select count(*) from specialty_bridge;
--156209
--161368
--159485

drop table MCM_Total_1;
select  a.*,b.spec1 as specialty,Spec1Cod,spec2,spec3, 
substring(call_date_new,1,7) as Month,
case when substring(call_date_new,6,2) in ('01','02','03') then substring(call_date_new,1,4)+'Q1'
     when substring(call_date_new,6,2) in ('04','05','06') then substring(call_date_new,1,4)+'Q2'
	 when substring(call_date_new,6,2) in ('07','08','09') then substring(call_date_new,1,4)+'Q3'
	 when substring(call_date_new,6,2) in ('10','11','12') then substring(call_date_new,1,4)+'Q4'
	 end as Quarter,
substring(call_date_new,1,4) as Year,
case when call_type_new in ('EMAIL','F2F','PHONE','POST','Remote Detail') then 'Y' else 'N' end as call_type_flag5,
case when call_type_new in ('EMAIL','F2F','PHONE','Remote Detail') then 'Y' else 'N' end as call_type_flag4
into MCM_Total_1 
from MCM_Total a
left join specialty_bridge b
on a.OnekeyID = b.OnekeyID;


delete from MCM_Total_1
where substring(onekeyid,1,3) not like '%WNL%'
--2493
--(2493 rows affected)



update MCM_Total_1
set call_type_new = upper(call_type_new)


update MCM_Total_1
set Commercial_Call_Medical_Call = upper(Commercial_Call_Medical_Call)

select count(*) from MCM_Total;
--18806179
--18806162
--19102916

select count(*) from MCM_Total_1;
--18118369
--18803597
--18803580
--19100334

select count(*),count(distinct onekeyID) from MCM_Total_1
where specialty is null;
--3313240	81040
--3348935	81482
--3383324	82479
--3383324	82479
--3645047	86380


select Commercial_Call_Medical_Call,count(*) from MCM_Total_1
where Year >= '2022'
and call_type_flag5 = 'Y'
group by Commercial_Call_Medical_Call
order by 1
/*
COMMERCIAL	9779630
MEDICAL	149517
OTHERS	138154
*/


update MCM_Total_1
set Commercial_Call_Medical_Call = 'OTHERS'
where Commercial_Call_Medical_Call = 'OTHER'


/*
Create a view for Takeda by adding total commerical and medical
*/
drop view V_MCM_Total_Takeda;
Create view V_MCM_Total_Takeda
as  
select distinct OnekeyId, 
'' as Initial_Call_Type,
'' as Initial_Call_Type2,
'' as Initial_Call_Date,
Call_Date_New,
Client_Name,
Call_Type_New,
Version,
'' as products,
'' as tier,
Commercial_Call_Medical_Call,
'' as Email_Opened,
'' as Email_Clicked,
'' as Rep,
specialty,
Spec1Cod,
spec2,
spec3,
Month,
Quarter,
Year
from MCM_Total_1
union all
select distinct OnekeyId, 
'' as Initial_Call_Type,
'' as Initial_Call_Type2,
'' as Initial_Call_Date,
Call_Date_New,
Client_Name,
Call_Type_New,
Version,
'' as products,
'' as tier,
'Total' as Commercial_Call_Medical_Call,
'' as Email_Opened,
'' as Email_Clicked,
'' as Rep,
specialty,
Spec1Cod,
spec2,
spec3,
Month,
Quarter,
Year
from MCM_Total_1
where Commercial_Call_Medical_Call in ('Commercial','Medical')


select Commercial_Call_Medical_Call,count(*) from V_MCM_Total_Takeda
group by Commercial_Call_Medical_Call



insert into MCM_TOTAL_janssen
select distinct a.onekeyid,
initial_call_type,
'  ' as initial_call_type2,
initial_Call_Date,
call_date_new,
Client_name,
call_type_new,version,products,tier,Commercial_Medical,open_status,click_status,Rep,
spec1 as specialty,Spec1Cod,spec2,spec3,
substring(call_date_new,1,7) as Month,
case when substring(call_date_new,6,2) in ('01','02','03') then substring(call_date_new,1,4)+'Q1'
     when substring(call_date_new,6,2) in ('04','05','06') then substring(call_date_new,1,4)+'Q2'
	 when substring(call_date_new,6,2) in ('07','08','09') then substring(call_date_new,1,4)+'Q3'
	 when substring(call_date_new,6,2) in ('10','11','12') then substring(call_date_new,1,4)+'Q4'
	 end as Quarter,
substring(call_date_new,1,4) as Year
--TO BE UPDATED !!!
from Janssen_2026Q3_option2_2 a
left join specialty_bridge b
on a.OnekeyID = b.OnekeyID
where not exists(select 1 from MCM_TOTAL_janssen c
where c.onekeyid = a.onekeyid
and c.Call_type_new = a.Call_type_new
and c.call_date_new = a.call_date_new
and c.client_name = a.client_name
and isnull(c.products,'1') = isnull(a.products,'1'));

select version,count(*) from MCM_TOTAL_janssen
group by version
order by 1
/*
2023Q1_Janssen	7899
2023Q3_Janssen	1251
2023Q3_Janssen_add	4556
2023Q4_Janssen	4632
2024Q1_Janssen	5637
2024Q3_Janssen	4367
2024Q4_Janssen	6511
2025Q1_Janssen	5611
2025Q2_Janssen	5938
2025Q3_Janssen	5334
2025Q4_Janssen	5673
2026Q1_Janssen	5732
2026Q2_Janssen	5714
2026Q3_Janssen	4275
Janssen_backdata	32106
*/

select distinct Commercial_Medical from MCM_TOTAL_janssen

update MCM_TOTAL_janssen
set Commercial_Medical = 'Medical'
where Commercial_Medical = 'Medical Call'

update MCM_TOTAL_janssen
set Commercial_Medical = 'Commercial'
where Commercial_Medical = 'Promotional Call'

update MCM_TOTAL_janssen
set Commercial_Medical = 'OTHERS'
where Commercial_Medical = 'Other Call' or Commercial_Medical is null

update MCM_TOTAL_janssen
set products = LTRIM(products)

update MCM_TOTAL_janssen
set open_status = '1'
where open_status = 'Y' or open_status='YES' or open_status='Delivered';

update MCM_TOTAL_janssen
set open_status = '0'
where open_status = 'N' or open_status='NO';

update MCM_TOTAL_janssen
set click_status = '1'
where click_status = 'Y' or click_status = 'YES';

update MCM_TOTAL_janssen
set click_status = '0'
where click_status = 'N' or click_status = 'NO';

select distinct open_status,click_status from MCM_TOTAL_janssen


/*Create a separate view for Janssen*/
drop view V_MCM_Total_Janssen;
create view V_MCM_Total_Janssen
as
select OnekeyId,Initial_Call_Type,Initial_Call_Type2, initial_Call_Date, Call_Date_New,Client_Name,
Call_Type_New,Version,products,tier,Commercial_Call_Medical_Call,Email_Opened,Email_Clicked,Rep,
specialty,Spec1Cod,spec2,spec3,
Month,
Quarter,
Year 
from MCM_Total_1
---!!! TO BE UPDATED
where version not in  ('Janssen_backdata','2023Q1_Janssen','2023Q2_Janssen',
					'2023Q3_Janssen','2023Q3_Janssen_add','2023Q4_Janssen','2024Q1_Janssen','2024Q3_Janssen','2024Q4_Janssen','2025Q1_Janssen',
					'2025Q2_Janssen','2025Q3_Janssen_email','2025Q3_Janssen','2025Q4_Janssen','2025Q4_Janssen_email',
					'2026Q1_Janssen','2026Q1_Janssen_email','2026Q2_Janssen','2026Q2_Janssen_email','2026Q3_Janssen','2026Q3_Janssen_email')
union all
select * from MCM_TOTAL_janssen
union all
select OnekeyId,Initial_Call_Type,Initial_Call_Type2, initial_Call_Date, Call_Date_New,Client_Name,
Call_Type_New,Version,products,tier,
'Total' as Commercial_Call_Medical_Call,
Email_Opened,Email_Clicked,Rep,
specialty,Spec1Cod,spec2,spec3,
Month,
Quarter,
Year 
from MCM_Total_1
where Commercial_Call_Medical_Call in ('Commercial','Medical');

select count(*) from MCM_Total_1;
--15330203
--15741400
--16337930
--17508215
--17600376
--18803597
--19100334

select count(*) from V_MCM_Total_Janssen; 
--26185456
--26980772
--28152181
--30457209
--30612554
--32994413
--33553851

select distinct len(Call_Date_New) from V_MCM_Total_Janssen;
--10

select distinct substring(Call_Date_New,1,4) from V_MCM_Total_Janssen
order by 1;

select distinct substring(Call_Date_New,6,2) from V_MCM_Total_Janssen
order by 1;

select distinct substring(Call_Date_New,9,2) from V_MCM_Total_Janssen
order by 1;


/*Should have 7 different values*/
select distinct call_type_new from V_MCM_Total_Janssen
order by 1;


select distinct Commercial_Call_Medical_Call from V_MCM_Total_Janssen;

select distinct Email_Opened,Email_Clicked from V_MCM_Total_Janssen;



drop table MCM_total_Flexview;
select Client_name,
Call_type_new,
Version,
Products,
Tier,
Commercial_Call_Medical_Call,
Email_Opened,Email_Clicked,Rep,specialty,spec2,spec3,
replace(Month,'-','') as Month,
Quarter,Year,call_type_flag5,call_type_flag4,
count(*) as Visits
into MCM_total_Flexview
from MCM_total_1
group by Client_name,
Call_type_new,
Version,
Products,
Tier,
Email_Opened,Email_Clicked,Rep,specialty,spec2,spec3,
Month,Quarter,Year,call_type_flag5,call_type_flag4,Commercial_Call_Medical_Call

select quarter,call_type_new,sum(Visits) from MCM_total_Flexview
group by quarter,call_type_new
order by 2,1






















