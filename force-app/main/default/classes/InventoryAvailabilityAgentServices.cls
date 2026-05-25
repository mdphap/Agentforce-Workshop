public with sharing class InventoryAvailabilityAgentServices
{
    public class InputParameters
    {
         @InvocableVariable(required=true label='Operation' description='Operation to perform on selected products')
        public String operation;

        @InvocableVariable(required=true label='Selected Product Code' description='Selected product code for processing')
        public String selected_product_code;

        @InvocableVariable(required=true label='Selected Product Quantity' description='Selected product quantity for processing')
        public Decimal selected_product_quantity;
    }

    public class OutputParameters
    {
        @InvocableVariable(label='Product Available' description='Product Is Available')
        public Boolean success;

        @InvocableVariable(label='Cart To Process' description='Cart To Process After Availability Checking')
        public List<CartItem> cart_items;
    }

    @InvocableMethod(label='Check product availability and itemize' description='Check product availability and convert to cart item format')
    public static List<OutputParameters> processSelectedProducts(List<InputParameters> inputs)
    {
        List<OutputParameters> outputs = new List<OutputParameters>();

        Map<String, PriceBookEntry> productByCode = getListedProducts();

        for (InputParameters input : inputs)
        {
            OutputParameters output = new OutputParameters();
            output.cart_items = new List<CartItem>();
            CartItem tmpCartItem = new CartItem();
            
            switch on input.operation
            {
                when 'check-and-itemize' {
                    // TODO: perform product availability checking here

                    // itemize
                    PriceBookEntry productData = productByCode.get(input.selected_product_code);
                    tmpCartItem = itemize(productData, input.selected_product_quantity);
                }	
                when 'itemize' {
                    // itemize
                    PriceBookEntry productData = productByCode.get(input.selected_product_code);
                    tmpCartItem = itemize(productData, input.selected_product_quantity);
                }
                when else {
                    tmpCartItem.setItemAvailabilityWarningMessage('Not Supported Operation');
                }
            }

            output.cart_items.add(tmpCartItem);
            output.success = String.isBlank(tmpCartItem.ItemAvailabilityWarningMessage);
            outputs.add(output);
        }

        return outputs;
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

    private static CartItem itemize(PriceBookEntry productData, Decimal quantity)
    {
        CartItem result = new CartItem();

        if (productData != null) {
            result.setProductName(productData.Product2.Name)
                    .setProductCode(productData.Product2.ProductCode)
                    .setUnitOfMeasure(productData.Product2.QuantityUnitOfMeasure)
                    .setPricePerUnit(productData.UnitPrice)
                    .setQuantity(quantity);
        } else {
            result.setItemAvailabilityWarningMessage('Product Data Not Found');
        }

        return result;
        
    }
}