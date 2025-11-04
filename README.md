# 🎓 Internships Informer Bot

An intelligent automation system that monitors Telegram channels for internship opportunities and automatically filters and forwards relevant opportunities to WhatsApp. Perfect for students looking for internships matching specific criteria.

## 📋 Overview

This project combines two powerful automation approaches:

1. **Telegram Auto-Forwarder** - A Python script using Telethon to monitor multiple Telegram channels and forward messages to a designated bot
2. **n8n Workflow** - An AI-powered workflow that intelligently filters internship posts and sends notifications via WhatsApp

## ✨ Features

- 🤖 **Automated Monitoring**: Continuously watches multiple Telegram channels for new posts
- 🧠 **AI-Powered Filtering**: Uses Google Gemini AI to intelligently analyze messages
- 🎯 **Smart Criteria Matching**: Filters internships based on:
  - Graduation year (2027)
  - Specific roles (Software Developer/Engineer Intern, Product Design Intern)
  - Excludes hackathons, events, and webinars
- 📱 **WhatsApp Notifications**: Sends formatted notifications with application links
- 🔄 **Real-time Processing**: Instant forwarding and filtering of opportunities
- 🐳 **Dockerized**: Easy deployment with Docker support

## 🏗️ Architecture

```
Telegram Channels → Python Forwarder → Telegram Bot → n8n Workflow → AI Filter → WhatsApp
```

### Component Breakdown

1. **Telegram Auto-Forwarder** (`telegram Autoforward.py`)
   - Monitors source channels using Telethon library
   - Forwards all messages to a designated Telegram bot
   - Runs continuously in the background

2. **n8n Workflow** (`Internship Informer.json`)
   - **Telegram Trigger**: Receives forwarded messages
   - **AI Agent**: Analyzes message content using Google Gemini
   - **Structured Output Parser**: Ensures consistent JSON output
   - **If Node**: Checks if message meets criteria
   - **HTTP Request**: Sends WhatsApp message via API

## 🚀 Getting Started

### Prerequisites

- Python 3.11+
- Docker (optional, for containerized deployment)
- n8n instance (self-hosted or cloud)
- Telegram API credentials
- Google Gemini API key
- WhatsApp Business API or compatible service

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/Unknown-Geek/Internships-Informer-Bot.git
cd Internships-Informer-Bot
```

#### 2. Set Up Python Forwarder

**Install Dependencies:**

```bash
pip install -r requirements.txt
```

**Configure Telegram Credentials:**

Edit `telegram Autoforward.py` and replace with your credentials:

```python
api_id = YOUR_API_ID
api_hash = "YOUR_API_HASH"
```

**Get Telegram API Credentials:**
1. Visit https://my.telegram.org
2. Log in with your phone number
3. Go to "API Development Tools"
4. Create a new application
5. Copy your `api_id` and `api_hash`

**Update Source Channels:**

Modify the `source_channels` list with channels you want to monitor:

```python
source_channels = [
    "dot_aware",
    "internfreak",
    "gocareers",
    # Add more channels...
]
```

**Set Target Bot:**

```python
target_chat = "@YourBotUsername"
```

**Run the Forwarder:**

```bash
python "telegram Autoforward.py"
```

On first run, you'll be prompted to authenticate with your Telegram account.

#### 3. Deploy with Docker (Alternative)

```bash
docker build -t internship-forwarder .
docker run -d --name internship-bot -v $(pwd):/app internship-forwarder
```

The volume mount ensures your session file persists across container restarts.

#### 4. Set Up n8n Workflow

**Import the Workflow:**

1. Open your n8n instance
2. Go to Workflows → Import from File
3. Select `Internship Informer.json`
4. Click Import

**Configure Credentials:**

Set up the following credentials in n8n:

1. **Telegram API**
   - Create a bot via [@BotFather](https://t.me/botfather)
   - Copy the bot token
   - Add to n8n credentials

2. **Google Gemini API**
   - Get API key from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Add to n8n credentials as "Google Gemini(PaLM) Api"

3. **WhatsApp API**
   - Update the HTTP Request node with your WhatsApp API endpoint
   - Replace the phone number in the `to` parameter
   - Configure authentication if required

**Update HTTP Request Node:**

```json
{
  "url": "YOUR_WHATSAPP_API_ENDPOINT",
  "to": "YOUR_PHONE_NUMBER",
  "message": "{{ $('AI Agent').item.json.output.whatsapp_message }}"
}
```

**Activate the Workflow:**

Click "Active" toggle in the top-right corner of the workflow.

## 🎛️ Configuration

### Filtering Criteria

The AI agent uses the following rules (customizable in the workflow):

```
1. Must be an internship opportunity
2. Open to 2027 graduates
3. Role must be one of:
   - Software Developer Intern
   - Software Engineer Intern
   - Product Design Intern
4. Excludes: hackathons, events, webinars, non-internship jobs
```

### Customizing Filters

Edit the system message in the "AI Agent" node to modify criteria:

- Change graduation year
- Add/remove eligible roles
- Adjust message format
- Include additional fields

### Example Output Format

When a qualifying internship is found:

```
💼 *Software Engineer Intern (2025–2027)*
Company: Google
Location: Bangalore
Eligibility: 2027 graduates
Apply here: https://careers.google.com/internships
```

## 📊 Monitored Channels

Default channels (can be customized):
- `dot_aware`
- `internfreak`
- `gocareers`
- `Engineering_Govt_Private_Jobs`
- `internshipsAlerts`

## 🔧 Troubleshooting

### Python Forwarder Issues

**"Session file not found"**
- Delete `forwarder_session.session` and re-authenticate

**"FloodWaitError"**
- Telegram rate limit hit; wait before restarting

**"Cannot forward message"**
- Ensure target bot has started a chat with your account
- Check bot permissions

### n8n Workflow Issues

**"Telegram Trigger not receiving messages"**
- Verify bot token is correct
- Ensure webhook is properly configured
- Check bot has messages from the forwarder

**"AI Agent returning invalid JSON"**
- Enable "Auto Fix" in Structured Output Parser
- Check Google Gemini API quota

**"WhatsApp not sending"**
- Verify API endpoint is accessible
- Check phone number format (+country code)
- Validate API authentication

## 🛠️ Development

### Project Structure

```
Internships-Informer-Bot/
├── telegram Autoforward.py   # Telegram monitoring script
├── Internship Informer.json  # n8n workflow definition
├── requirements.txt           # Python dependencies
├── Dockerfile                 # Container configuration
└── README.md                  # This file
```

### Adding New Channels

1. Join the channel on Telegram
2. Get the channel username (without @)
3. Add to `source_channels` list
4. Restart the forwarder

### Modifying AI Prompt

The AI prompt is in the "AI Agent" node's system message. Key sections:

- **Rules**: Define matching criteria
- **Output Format**: Specify JSON structure
- **Examples**: Show expected output

## 📝 Dependencies

### Python
- `telethon>=1.34.0` - Telegram client library
- `cryptg>=0.4.0` - Cryptography acceleration

### n8n Nodes
- `n8n-nodes-base.telegramTrigger`
- `@n8n/n8n-nodes-langchain.agent`
- `@n8n/n8n-nodes-langchain.lmChatGoogleGemini`
- `@n8n/n8n-nodes-langchain.outputParserStructured`
- `n8n-nodes-base.if`
- `n8n-nodes-base.httpRequest`

## 🔐 Security Considerations

- **Never commit API credentials** to version control
- Store sensitive data in environment variables
- Use `.gitignore` to exclude session files
- Rotate API keys regularly
- Restrict WhatsApp API access to trusted IPs
- Use HTTPS for all API endpoints

### Recommended .gitignore

```
*.session
*.session-journal
.env
config.py
__pycache__/
*.pyc
```

## 🚀 Deployment

### Self-Hosted n8n

```bash
docker run -it --rm \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### Production Considerations

- Use environment variables for credentials
- Set up monitoring and logging
- Configure automatic restarts
- Use process managers (PM2, systemd)
- Set up backup for session files
- Implement rate limiting

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is open source. Please check the repository for license information.

## 🙏 Acknowledgments

- [Telethon](https://github.com/LonamiWebs/Telethon) - Telegram client library
- [n8n](https://n8n.io/) - Workflow automation platform
- [Google Gemini](https://ai.google.dev/) - AI language model
- Telegram community for internship channels

## 📧 Contact

For questions or support, please open an issue on GitHub.

---

**Made with ❤️ for students seeking internships**
