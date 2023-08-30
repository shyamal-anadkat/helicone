CREATE TABLE IF NOT EXISTS default.provider_log (
    `response_id` Nullable(UUID),
    `response_created_at` Nullable(DateTime64),
    `latency` Nullable(Int64),
    `status` Int64,
    `completion_tokens` Nullable(Int64),
    `prompt_tokens` Nullable(Int64),
    `model` String,
    `request_id` UUID,
    `request_created_at` DateTime64,
    `auth_hash` String,
    `user_id` String,
    `organization_id` UUID,
    `feedback_created_at` Nullable(DateTime64),
    `feedback_id` Nullable(UInt64),
    `rating` Nullable(Bool),
    `created_at` DateTime DEFAULT now()
) ENGINE = ReplacingMergeTree() PRIMARY KEY (
    organization_id,
    user_id,
    request_created_at,
    status,
    model,
    request_id
)
ORDER BY (
        organization_id,
        user_id,
        request_created_at,
        status,
        model,
        request_id
    )