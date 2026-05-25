public with sharing class OrderCheckoutAgentServices
{
    public class InputParameters
    {
        @InvocableVariable(required=true label='Customer Email' description='Customer Email')
        public String email;

        @InvocableVariable(required=true label='Customer Name' description='Customer Name')
        public String name;

        @InvocableVariable(required=true label='Customer Delivery Address' description='Customer Delivery Address')
        public String address;

        @InvocableVariable(required=true label='Shopping Cart' description='Shopping cart to checkout')
        public Cart shopping_cart;
    }

    public class OutputParameters
    {
        @InvocableVariable(label='Order Information' description='Order Information')
        public Order checkout_order;
    }

    private static Id personAccountRecordTypeId = Schema.Account.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().get('PersonAccount').getRecordTypeId();

    @InvocableMethod(label='Shopping Cart Checkout' description='Create Order from online shopping cart')
    public static List<OutputParameters> checkout(List<InputParameters> inputs)
    {
        Map<String, Account> accountByEmail = getAccountByEmail(inputs);

        Pricebook2 rosaAndMannyPriceBook = getRosaAndMannyPriceBook();

        Map<String, PriceBookEntry> listedProducts = getListedProducts();

        List<Account> accountsToCreate = new List<Account>();

        List<OutputParameters> outputs = new List<OutputParameters>();

        List<Order> ordersToCreate = new List<Order>();

        List<OrderItem> orderItemsToCreate = new List<OrderItem>();

        for (InputParameters input : inputs)
        {
            OutputParameters output = new OutputParameters();
            outputs.add(output);
            
            // order
            Order tmpOrder = new Order(
                OrderReferenceNumber = UUID.randomUUID().toString(),
                EffectiveDate = Date.today(),
                Type = 'Online',
                Pricebook2Id = rosaAndMannyPriceBook.Id,
                Original_Delivery_Address__c = input.address,
                Status = 'Draft'
            );

            Account orderAccount = accountByEmail.get(input.email) ?? createNewPersonAccount(input.email, input.name);
            tmpOrder.putSObject('Account', orderAccount);
            if (String.isBlank(orderAccount.Id)) {accountsToCreate.add(orderAccount);}

            // order line item
            for (CartItem item : input.shopping_cart.CartItems) {

                if (!listedProducts.containsKey(item.ProductCode)) {continue;}

                OrderItem tmpOrderItem = new OrderItem(
                    Product2Id = listedProducts.get(item.ProductCode).Product2Id,
                    PricebookEntryId = listedProducts.get(item.ProductCode).Id,
                    Quantity = item.Quantity,
                    ReferencePrice = item.PricePerUnit,
                    UnitPrice = item.PricePerUnit,
                    ServiceDate = Date.today(),
                    Description = listedProducts.get(item.ProductCode).Product2.Description
                );

                tmpOrderItem.putSObject('Order', tmpOrder);

                orderItemsToCreate.add(tmpOrderItem);
            }

            output.checkout_order = tmpOrder;
        }

        // insert person account
        if (!accountsToCreate.isEmpty()) {
            Database.insert(accountsToCreate);
        }

        // insert order
        for (OutputParameters output : outputs) {
            output.checkout_order.AccountId = output.checkout_order.Account.Id;
            ordersToCreate.add(output.checkout_order);
        }

        Database.insert(ordersToCreate);

        // insert order line item
        for (OrderItem tmpOrderItem : orderItemsToCreate) {
            tmpOrderItem.OrderId = tmpOrderItem.Order.Id;
        }

        Database.insert(orderItemsToCreate);

        return outputs;
    }

    private static Map<String, Account> getAccountByEmail(List<InputParameters> inputs)
    {
        Set<String> emails = new Set<String>();

        for (InputParameters input : inputs)
        {
            if (String.isNotBlank(input.email)) {
                emails.add(input.email);
            }
        }

        Map<String, Account> accountByEmail = new Map<String, Account>();

        for (Account tmpAccount : [
                                    SELECT Id, Lastname, PersonEmail, PersonContactId, ShippingAddress
                                    FROM Account
                                    WHERE PersonEmail IN :emails
                                    AND IsPersonAccount = TRUE
                                ]) {
            accountByEmail.put(tmpAccount.PersonEmail, tmpAccount);
        }

        return accountByEmail;
    }

    private static Pricebook2 getRosaAndMannyPriceBook()
    {
        return [SELECT Id FROM Pricebook2 WHERE Name = 'Rosa & Manny Corner Store'];
    }

    private static Account createNewPersonAccount(String email, String name)
    {
        return new Account(
            LastName = name,
            PersonEmail = email,
            RecordTypeId = personAccountRecordTypeId
        );
    }

    private static Map<String, PriceBookEntry> getListedProducts()
    {
        Map<String, PriceBookEntry> productByCode = new Map<String, PriceBookEntry>();

        for (PriceBookEntry pbe : [
                                    SELECT  UnitPrice,
                                            Product2Id, Product2.Name, Product2.Description, Product2.Family, Product2.ProductCode, Product2.QuantityUnitOfMeasure 
                                    FROM PriceBookEntry
                                    WHERE Pricebook2.Name = 'Rosa & Manny Corner Store'
                                ])
            {
                productByCode.put(pbe.Product2.ProductCode, pbe);
            }
        
        return productByCode;
    }
}