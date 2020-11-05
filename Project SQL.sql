--  1. Create a database called `credit_card_classification`.
CREATE DATABASE credit_card_classification

-- 2. Create a table `credit_card_data` with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns.
CREATE TABLE credit_card_data (
  `Customer Number` INT,
  `Offer Accepted` VARCHAR(255),
  `Reward Type` VARCHAR(255),  
  `Mailer Type` VARCHAR(255),
  `Income Level` VARCHAR(255),
  `Bank Accounts Open` INT,
  `Overdraft Protection` VARCHAR(255),
  `Credit Rating` VARCHAR(255),
  `Credit Cards Held` INT,
  `Homes Owned` INT,
  `Household Size` INT,
  `Own Your Home` VARCHAR(255),
  `Average Balance` FLOAT,
  `Q1` INT,
  `Q2` INT,
  `Q3` INT,
  `Q4` INT
)


SHOW VARIABLES LIKE 'local_infile' ;  
SET GLOBAL local_infile = 1;


-- 4.  Select all the data from table `credit_card_data` to check if the data was imported correctly.
select * from credit_card_data ; 

--  5.  Use the _alter table_ command to drop the column `q4_balance` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data
DROP Q4 ; 

select * from credit_card_data limit 10 ; 

-- 6.  Use sql query to find how many rows of data you have.
select count(*) as number_rows from credit_card_data ; 

-- 7.  Now we will try to find the unique values in some of the categorical columns:

    -- What are the unique values in the column `Offer_accepted`?
    select distinct `Offer Accepted` from credit_card_data ; 
    
    -- What are the unique values in the column `Reward`?
        select distinct `Reward Type` from credit_card_data ; 

    -- What are the unique values in the column `mailer_type`?
       select distinct `Mailer Type` from credit_card_data ; 

    -- What are the unique values in the column `credit_cards_held`?
        select distinct `Credit Cards Held` from credit_card_data ; 

    -- What are the unique values in the column `household_size`?
    select distinct `Household Size` from credit_card_data ; 
    
-- 8.  Arrange the data in a decreasing order by the `average_balance` of the house. Return only the `customer_number` of the top 10 customers with the highest `average_balances` in your data.
select * from credit_card_data order by `Average Balance` desc limit 10 ; 

-- 9.  What is the average balance of all the customers in your data?
select round(avg(`Average Balance`)) as avg_balance_customers from credit_card_data ; 

-- 10
 -- What is the average balance of the customers grouped by `Income Level`? The returned result should have only two columns, income level and `Average balance` of the customers. Use an alias to change the name of the second column.
select `Income Level`,round(avg(`Average Balance`)) as Average_Balance from credit_card_data group by `Income Level`; 

 -- What is the average balance of the customers grouped by `number_of_bank_accounts_open`? The returned result should have only two columns, `number_of_bank_accounts_open` and `Average balance` of the customers. Use an alias to change the name of the second column.
select `Bank Accounts Open`,round(avg(`Average Balance`)) as Average_Balance from credit_card_data group by `Bank Accounts Open`; 
 
  -- What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select `Credit Rating`,round(avg(`Average Balance`)) as Average_Balance from credit_card_data group by `Credit Rating`; 

  -- Is there any correlation between the columns `credit_cards_held` and `number_of_bank_accounts_open`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select `Bank Accounts Open`, sum(`Credit Cards Held`) from credit_card_data group by `Bank Accounts Open`; 
select `Bank Accounts Open`, count(`Credit Cards Held`) from credit_card_data group by `Bank Accounts Open`; 

--  11. Your managers are only interested in the customers with the following properties:

    -- Credit rating medium or high
    -- Credit cards held 2 or less
    -- Owns their own home
    -- Household size 3 or more
    -- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them? Can you filter the customers who accepted the offers here?
    
    select * 
from credit_card_data 
where `Credit Rating` IN ('Medium', 'High') 
and `Credit Cards Held`<=2
and `Own Your Home`='yes'
and `Household Size`>=3
and `Offer Accepted`='yes'; 

-- 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.

-- select * from credit_card_data where `Average Balance` < (select round(avg(`Average Balance`)) as avg_balance_customers from credit_card_data) order by `Average Balance` asc ; 

select `Customer Number`, `Average Balance` from credit_card_data
where `Average Balance` < (select avg(`Average Balance`) from credit_card_data);

--  13. Since this is something that the senior management is regularly interested in, create a view of the same query.
create view customer_avg_balance as
select * from credit_card_data where `Average Balance` > (select round(avg(`Average Balance`)) as avg_balance_customers from credit_card_data) order by `Average Balance` asc ; 

-- 14. What is the number of people who accepted the offer vs number of people who did not?
select `Offer Accepted`, count(*) as count from credit_card_data group by `Offer Accepted`; 

-- 15. Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
select `Credit Rating`,round(avg(`Average Balance`)) as Average_Balance from credit_card_data group by `Credit Rating`; 

-- 16. In the database, which all types of communication (`mailer_type`) were used and with how many customers?
select `Mailer Type`, count(distinct `Customer Number`) as count_customer from credit_card_data group by `Mailer Type`; 

-- 17. Provide the details of the customer that is the 11th least `Q1_balance` in your database.
select * from credit_card_data order by `Q1` asc limit 10,1;
select * from credit_card_data order by `Q1` asc limit 11;
