
    with
   payments as (

        SELECT *
        FROM {{ ref('stg_stripe__payments') }}

    ),

    orders as (

        SELECT *
        FROM {{ ref('stg_jaffle_shop__orders') }}

    ),

    order_payments as (
    select
        order_id,
        sum (case when payment_status = 'success' then payment_amount end) as payment_amount

    from payments
    group by 1
),


    final as (

        select orders.order_id, 
        orders.customer_id,
        coalesce(order_payments.payment_amount, 0) as payment_amount
        from orders
        left join order_payments
        using (order_id)
    )
    
    select * from final