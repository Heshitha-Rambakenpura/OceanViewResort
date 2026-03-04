package com.oceanview.model;

/**
 * CashPayment - Extends Payment (Strategy Pattern)
 * @version 1.0.0
 */
public class CashPayment extends Payment {

    private double amountTendered;
    private double changeAmount;

    // ─── CONSTRUCTORS ───
    public CashPayment() {}

    public CashPayment(Bill bill, double amount, double amountTendered) {
        super(bill, amount);
        this.amountTendered = amountTendered;
        this.changeAmount   = calculateChange();
    }

    // ─── CALCULATE CHANGE ───
    public double calculateChange() {
        return this.amountTendered - this.getAmount();
    }

    // ─── STRATEGY PATTERN - processPayment implementation ───
    @Override
    public boolean processPayment() {
        if (amountTendered >= getAmount()) {
            this.changeAmount = calculateChange();
            setPaymentStatus("SUCCESS");
            return true;
        }
        setPaymentStatus("FAILED");
        return false;
    }

    // ─── GETTERS AND SETTERS ───
    public double getAmountTendered()           { return amountTendered; }
    public double getChangeAmount()             { return changeAmount; }
    public void setAmountTendered(double amt)   { this.amountTendered = amt; }
    public void setChangeAmount(double change)  { this.changeAmount = change; }
}