set :slackistrano, {
  channel: "#general",
  team: "automatic-agent",
  webhook: YAML.load(`rails credentials:show`).dig("slack_webhook_url"),
}

