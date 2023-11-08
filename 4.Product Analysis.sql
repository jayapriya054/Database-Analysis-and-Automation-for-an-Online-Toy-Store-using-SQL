# PRODUCT SALES ANALYSIS- To analyse How each product contribute to the business and how product launches impact the overall portfolio

/*USE CASES-
-- Analysing sales and revenue by products.
-- Monitoring the impact of adding a new product to product portfolio.
-- Watching product sales trends to understand overall health of business.

-- general terms---->total sales/ total revenue- total cost = net profit, sales margin= profit % Revenue
-- SUM(PRICE_USD) =REVENUE
-- MARGIN= SUM(PRICE_USD- COGS_USD)
*/


# TASK 1- PRODUCT LEVEL SALES ANALYSIS.
# To Pull monthly trends to date for a number of sales, total revenue, and total margin generated for the business.

USE mavenfuzzyfactory;
SELECT 
    YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT order_id) AS number_of_sales,
    SUM(price_usd) AS total_revenue,
    SUM(price_usd - cogs_usd) AS total_margin
FROM
    orders
WHERE
    created_at < '2013-01-04'
GROUP BY YEAR(created_at) , MONTH(created_at);


# TASK 2- ANALYSING PRODUCT LAUNCH IMPACT
/* To pull  monthly order volume, overall conversion rates, revenue per session and a breakdwn of sales by product  till Apr 1,2012
 for a product launched on 6th Jan and the task is .
*/

SELECT 
    YEAR(website_sessions.created_at) AS yr,
    MONTH(website_sessions.created_at) AS mo,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    SUM(orders.price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session,
    COUNT(DISTINCT CASE
            WHEN primary_product_id = 1 THEN order_id
            ELSE NULL
        END) AS product_one_orders,
    COUNT(DISTINCT CASE
            WHEN primary_product_id = 2 THEN order_id
            ELSE NULL
        END) AS product_two_orders
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
    website_sessions.created_at < '2013-04-05'
        AND website_sessions.created_at > '2012-04-01'
GROUP BY 1 , 2;

#TASK 3- PRODUCT REFUND ANALYSIS
#Understanding refund rates for products at different prince points.
/* To pull monthly product refund rates by product. */

SELECT 
    YEAR(order_items.created_at) AS yr,
    MONTH(order_items.created_at) AS mo,
    COUNT(DISTINCT CASE
            WHEN product_id = 1 THEN order_items.order_item_id
            ELSE NULL
        END) AS p1_orders,
    COUNT(DISTINCT CASE
            WHEN product_id = 1 THEN order_item_refunds.order_item_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN product_id = 1 THEN order_items.order_item_id
            ELSE NULL
        END) AS p1_refund_rt,
    COUNT(DISTINCT CASE
            WHEN product_id = 2 THEN order_items.order_item_id
            ELSE NULL
        END) AS p2_orders,
    COUNT(DISTINCT CASE
            WHEN product_id = 2 THEN order_item_refunds.order_item_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN product_id = 2 THEN order_items.order_item_id
            ELSE NULL
        END) AS p2_refund_rt,
    COUNT(DISTINCT CASE
            WHEN product_id = 3 THEN order_items.order_item_id
            ELSE NULL
        END) AS p3_orders,
    COUNT(DISTINCT CASE
            WHEN product_id = 3 THEN order_item_refunds.order_item_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN product_id = 3 THEN order_items.order_item_id
            ELSE NULL
        END) AS p3_refund_rt,
    COUNT(DISTINCT CASE
            WHEN product_id = 4 THEN order_items.order_item_id
            ELSE NULL
        END) AS p4_orders,
    COUNT(DISTINCT CASE
            WHEN product_id = 4 THEN order_item_refunds.order_item_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN product_id = 4 THEN order_items.order_item_id
            ELSE NULL
        END) AS p4_refund_rt
FROM
    order_items
        LEFT JOIN
    order_item_refunds ON order_items.order_item_id = order_item_refunds.order_item_id
WHERE
    order_items.created_at < '2014-10-15'
GROUP BY 1 , 2;

