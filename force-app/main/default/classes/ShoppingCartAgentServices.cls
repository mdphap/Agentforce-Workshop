public with sharing class ShoppingCartAgentServices
{
    public class InputParameters
    {
        @InvocableVariable(required=true label='Operation' description='Operation to perform on selected product against cart')
        public String operation;

        @InvocableVariable(required=true label='Cart' description='Current shopping cart with its cart items')
        public Cart cart;

        @InvocableVariable(required=true label='Selected Product Items' description='Selected product items for processing')
        public List<CartItem> selected_products;
    }

    public class OutputParameters {
        @InvocableVariable(label='Updated Cart' description='Shopping cart after processing selected product items')
        public Cart updated_cart;
    }

    @InvocableMethod(label='Process selected item to shopping cart' description='Process selected item to shopping cart')
    public static List<OutputParameters> processSelectedProducts(List<InputParameters> inputs)
    {
        List<OutputParameters> outputs = new List<OutputParameters>();

        for (InputParameters input : inputs)
        {
            OutputParameters output = new OutputParameters();
            
            Map<String, CartItem> currentItems = groupCartItemsByProductCode(input.cart.CartItems);

            Map<String, CartItem> selectedItems = groupCartItemsByProductCode(input.selected_products);

            for (String productCode : selectedItems.keySet()) {

                Decimal currentItemQuantity = currentItems.get(productCode)?.Quantity ?? 0;

                Decimal selectedItemQuantity = selectedItems.get(productCode)?.Quantity ?? 0;

                switch on input.operation {
                    when 'add' {
                        if (currentItems.containsKey(productCode)) {
                            // add more quantity to a current item
                            CartItem currentItem = currentItems.get(productCode);
                            currentItem.Quantity = currentItemQuantity + selectedItemQuantity;
                            currentItems.put(productCode, currentItem);
                        } else {
                            // add new item
                            CartItem selectedItem = selectedItems.get(productCode);
                            currentItems.put(productCode, selectedItem);
                        }
                    }
                    when 'remove'
                    {
                        // do not process if selected item is not in cart
                        if (!currentItems.containsKey(productCode)) {continue;}

                        Decimal newQuantity = Math.max(currentItemQuantity - selectedItemQuantity, 0);

                        if (newQuantity > 0) {
                            CartItem currentItem = currentItems.get(productCode);
                            currentItem.Quantity = newQuantity;
                            currentItems.put(productCode, currentItem);
                        } else {
                            currentItems.remove(productCode);
                        }
                    }
                    when 'update'
                    {
                        // do not process if selected item is not in cart
                        if (!currentItems.containsKey(productCode)) {continue;}

                        if (selectedItemQuantity > 0) {
                            CartItem currentItem = currentItems.get(productCode);
                            currentItem.Quantity = selectedItemQuantity;
                            currentItems.put(productCode, currentItem);
                        } else {
                            currentItems.remove(productCode);
                        }
                    }
                    when else
                    {
                        // do nothing
                    }
                }
            }

            output.updated_cart = new Cart();
            output.updated_cart.CartItems = currentItems.values();
            output.updated_cart.calculateCartTotalPrice();

            outputs.add(output);
        }


        return outputs;
    }

    private static Map<String, CartItem> groupCartItemsByProductCode(List<CartItem> cartItems)
    {
        Map<String, CartItem> result = new Map<String, CartItem>();

        for (CartItem item : cartItems) {
            result.put(item.ProductCode, (CartItem) JSON.deserializeStrict(JSON.serialize(item), CartItem.class));
        }

        return result;
    }
}