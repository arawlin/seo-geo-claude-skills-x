# 加密网站证据台账模板

本文档亦提供[英文版](./crypto-site-evidence-ledger-template.md)。

## 用途

任何发布高波动交易所数据、商业化推荐或产品流程截图的页面，都应使用这份模板。证据台账的目标，是阻止未经核验的声明进入生产环境。

## 最低规则

- 页面从草稿进入待审前，必须先建一条证据记录。
- 手续费、返佣、KYC、提币、地区可用性、奖励规则等声明，没有来源 URL 和核验时间就不能发布。
- 自动采集与人工核验必须分开记录。
- 来源模糊、冲突或只是估算时，必须把该条目标记为阻止发布。
- 当某条记录从阻止发布或已过期变成已核验时，要同步更新页面上的“最近核验日期”。

## 台账字段

- `claim_id`
- `page_slug`
- `claim_type`
- `claim_text`
- `source_url`
- `source_type`
- `checked_at`
- `checked_by`
- `evidence_path`
- `status`
- `next_review_trigger`
- `notes`

示例记录：

```csv
claim_id,page_slug,claim_type,claim_text,source_url,source_type,checked_at,checked_by,evidence_path,status,next_review_trigger,notes
CLM-001,exchange-rebates/binance,rebate-rate,"VIP 0 返佣比例为 20%",https://example.com/source,official-page,2026-04-18 09:00 UTC,editor-name,/evidence/binance-rebate-2026-04-18.png,verified,"费率表变化或 30 天","已对照公开费率表核验"
CLM-002,exchange-guides/kyc,kyc-rule,"买卡前需要完成一级 KYC",https://example.com/source,help-center,2026-04-18 09:20 UTC,reviewer-name,/evidence/kyc-help-center-2026-04-18.png,review-needed,"流程变化或 14 天","还需要人工走一遍产品流程"
```

## 空白工作模板

```csv
claim_id,page_slug,claim_type,claim_text,source_url,source_type,checked_at,checked_by,evidence_path,status,next_review_trigger,notes
CLM-___,,,,,,,,,,,
CLM-___,,,,,,,,,,,
CLM-___,,,,,,,,,,,
```

## 声明类型建议

- `fee`
- `rebate-rate`
- `bonus-rule`
- `kyc-rule`
- `withdrawal-limit`
- `supported-region`
- `product-flow`
- `legal-copy`
- `risk-warning`
- `comparison-data`

## 来源类型建议

- `official-page`
- `help-center`
- `terms-page`
- `support-ticket`
- `product-walkthrough`
- `manual-screenshot`
- `third-party-reference`
- `estimated`

## 状态规则

- `verified`：来源和复核完整，可以发布。
- `review-needed`：已有来源，但仍需人工确认或截图刷新。
- `stale`：曾经有效，但已经超出复核窗口。
- `blocked`：来源缺失、冲突，或强度不足以支撑发布。

## 复核触发条件

- 费率表变化。
- 返佣或注册奖励变化。
- KYC 或提币流程变化。
- 支持国家地区或支付方式变化。
- 截图和线上界面不再一致。
- 法律免责声明、编辑政策或返佣披露措辞发生变化。
- 页面超过预设复核周期仍未重新检查。

## 团队执行规则

1. 先记录来源 URL。
2. 再保存截图或归档副本。
3. 记录谁在什么时间核验。
4. 标记这条声明被哪些页面复用。
5. 在页面上线前写明下一次复核触发条件。
6. 当该条声明影响上线或信任决策时，把带日期的摘要写入 `memory/`。

## 什么情况算阻止发布

- 没有来源 URL。
- 没有核验时间。
- 来源与截图互相矛盾。
- 页面文案与已核验声明不一致。
- 高风险金融文案超过复核窗口。
- 返佣披露或风险提示依赖未经核验的表述。

## 推荐搭配文档

- [crypto-site-launch-qa-checklist-zh.md](./crypto-site-launch-qa-checklist-zh.md)
- [chinese-beginner-crypto-site-launch-playbook-zh.md](./chinese-beginner-crypto-site-launch-playbook-zh.md)
