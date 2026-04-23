---
name: setup-alert
description: Configure monitoring alerts for critical SEO and GEO metrics
argument-hint: "<metric type> <threshold>"
parameters:
  - name: alert_type
    type: string
    required: true
    description: "Alert type: ranking-drop, traffic-change, indexing-issue, backlink-change, geo-visibility, core-web-vitals, technical-error, conversion-rate, all-critical"
  - name: threshold
    type: string
    required: false
    description: Numeric or percentage threshold (e.g., -5, -20%, poor)
  - name: keywords
    type: string
    required: false
    description: Specific keywords to monitor (comma-separated)
  - name: severity
    type: string
    required: false
    description: "Alert priority: high, medium, low"
---

# Setup Alert Command

Configures proactive **monitoring alerts for critical SEO and GEO metrics**, defines intelligent thresholds, and establishes response playbooks.

## Usage

```
/seo:setup-alert ranking-drop threshold=-5 keywords="primary keywords"
/seo:setup-alert traffic-change threshold=-20%
/seo:setup-alert core-web-vitals threshold=poor
/seo:setup-alert all-critical
```

**Arguments:** Alert type (required): ranking-drop, traffic-change, indexing-issue, backlink-change, geo-visibility, core-web-vitals, technical-error, conversion-rate, all-critical. Optional: `threshold=`, `keywords=`, `pages=`, `severity=`, `notification=email|slack|sms`.

## Workflow

1. **Parse Alert Configuration** -- Identify type(s). `all-critical` sets up standard package (ranking drop, traffic change, indexing issue, CWV, backlink loss).
2. **Configure Alerts** -- Invoke `alert-manager`. Define thresholds, severity levels, notification frequency, trigger conditions, false positive filters, response playbooks.
3. **Compile Output**.

## Output Format

```markdown
## ALERT CONFIGURATION SUMMARY

Successfully configured [X] alert(s).

### Active Alerts
Per alert: Type, Severity, Threshold, Scope, Notification, Status.

### Notification Settings
Recipients, channels, routing rules per severity level.

### Response Playbooks
Per alert type: immediate actions, investigation steps, recovery, escalation.

### Testing & Validation
Test triggers, review playbooks, schedule threshold review.
```

## Tips

Start with loose thresholds and tighten over time. Use digest notifications for non-critical alerts (daily/weekly). Review alert effectiveness monthly.

## Related Skills

- [alert-manager](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/alert-manager/SKILL.md) | [rank-tracker](https://github.com/aaron-he-zhu/seo-geo-claude-skills/blob/main/monitor/rank-tracker/SKILL.md)
