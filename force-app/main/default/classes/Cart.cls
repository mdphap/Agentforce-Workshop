@JsonAccess(serializable='always' deserializable='always')
public with sharing class Cart
{
    @AuraEnabled
    public List<CartItem> CartItems;

    @AuraEnabled
    public Decimal CartTotalPrice;

    public Cart()
    {
        this.CartItems = new List<CartItem>();
    }

    public Cart calculateCartTotalPrice()
    {
        this.CartTotalPrice = 0;

        for (CartItem item : this.CartItems)
        {
            item.calculateCartItemPrice();
            
            Decimal tmp = item.CartItemPrice ?? 0;

            this.CartTotalPrice += tmp;
        }

        return this;
    }
}