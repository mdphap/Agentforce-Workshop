@JsonAccess(serializable='always' deserializable='always')
public class CartItem
{
    @AuraEnabled
    public String ProductName;

    @AuraEnabled
    public String ProductCode;

    @AuraEnabled
    public String UnitOfMeasure;

    @AuraEnabled
    public Decimal Quantity;

    @AuraEnabled
    public Decimal PricePerUnit;

    @AuraEnabled
    public Decimal CartItemPrice;

    @AuraEnabled
    public String ItemAvailabilityWarningMessage;

    public CartItem()
    {
        this.ProductName = this.ProductCode = This.UnitOfMeasure = '';
    }

    public CartItem setProductName(String ProductName)
    {
        this.ProductName = ProductName;

        return this;
    }

    public CartItem setProductCode(String ProductCode)
    {
        this.ProductCode = ProductCode;

        return this;
    }

    public CartItem setUnitOfMeasure(String UnitOfMeasure)
    {
        this.UnitOfMeasure = UnitOfMeasure;

        return this;
    }

    public CartItem setQuantity(Decimal Quantity)
    {
        this.Quantity = Quantity;

        this.calculateCartItemPrice();

        return this;
    }

    public CartItem setPricePerUnit(Decimal PricePerUnit)
    {
        this.PricePerUnit = PricePerUnit;

        this.calculateCartItemPrice();

        return this;
    }

    public CartItem setItemAvailabilityWarningMessage(String message)
    {
        this.ItemAvailabilityWarningMessage = message;

        this.ProductName = this.ProductCode = this.UnitOfMeasure = null;

        this.Quantity = this.CartItemPrice = null;

        return this;
    }

    public CartItem calculateCartItemPrice()
    {
        Decimal quantity = this.Quantity ?? 0;

        Decimal pricePerUnit = this.PricePerUnit ?? 0;

        this.CartItemPrice = quantity * pricePerUnit;

        return this;
    }
}