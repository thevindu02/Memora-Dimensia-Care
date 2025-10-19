-- Create guardian_subscriptions table
CREATE TABLE IF NOT EXISTS guardian_subscriptions (
    subscription_id BIGSERIAL PRIMARY KEY,
    guardian_id BIGINT NOT NULL REFERENCES guardians(guardian_id) ON DELETE CASCADE,
    patient_id BIGINT NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    plan_type VARCHAR(20) NOT NULL CHECK (plan_type IN ('BASIC', 'PREMIUM')),
    duration_months INTEGER NOT NULL CHECK (duration_months IN (3, 6, 12)),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('ACTIVE', 'EXPIRED', 'CANCELLED', 'PENDING')),
    auto_renew BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_active_subscription UNIQUE (guardian_id, patient_id, status)
);

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
    payment_id BIGSERIAL PRIMARY KEY,
    guardian_id BIGINT NOT NULL REFERENCES guardians(guardian_id) ON DELETE CASCADE,
    subscription_id BIGINT REFERENCES guardian_subscriptions(subscription_id) ON DELETE SET NULL,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
    currency VARCHAR(3) NOT NULL DEFAULT 'LKR',
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('CARD', 'PAYPAL', 'APPLE_PAY', 'GOOGLE_PAY')),
    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'SUCCESS', 'FAILED', 'REFUNDED', 'CANCELLED')),
    transaction_id VARCHAR(255),
    payhere_order_id VARCHAR(255) UNIQUE,
    payment_date TIMESTAMP,
    card_last_four VARCHAR(4),
    card_holder_name VARCHAR(255),
    payment_description VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better query performance
CREATE INDEX idx_subscriptions_guardian ON guardian_subscriptions(guardian_id);
CREATE INDEX idx_subscriptions_patient ON guardian_subscriptions(patient_id);
CREATE INDEX idx_subscriptions_status ON guardian_subscriptions(status);
CREATE INDEX idx_payments_guardian ON payments(guardian_id);
CREATE INDEX idx_payments_subscription ON payments(subscription_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_payments_order_id ON payments(payhere_order_id);

-- Add comments
COMMENT ON TABLE guardian_subscriptions IS 'Stores subscription plans for guardian-patient relationships';
COMMENT ON TABLE payments IS 'Stores all payment transactions for subscriptions';
COMMENT ON COLUMN guardian_subscriptions.plan_type IS 'BASIC or PREMIUM subscription plan';
COMMENT ON COLUMN guardian_subscriptions.duration_months IS 'Subscription duration: 3, 6, or 12 months';
COMMENT ON COLUMN payments.payhere_order_id IS 'Unique order ID from PayHere payment gateway';
