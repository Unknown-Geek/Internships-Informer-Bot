from telethon import TelegramClient, events

# Telegram API credentials (replace with yours)
api_id = 22243995
api_hash = "7c8bcf368fadeefa338b2ed173b5d571"

# Channels to monitor (usernames only, no 'https://t.me/')
source_channels = [
    "dot_aware",
    "internfreak",
    "gocareers",
    "Engineering_Govt_Private_Jobs",
    "internshipsAlerts"
]

# Where to forward (bot username or your own @username)
target_chat = "@MovieInfromerBot"  # ensure your bot has started a chat with you

# Create client session (local file = forwarder_session.session)
client = TelegramClient("forwarder_session", api_id, api_hash)

@client.on(events.NewMessage(chats=source_channels))
async def forward_post(event):
    try:
        # forward message to destination chat
        await client.forward_messages(target_chat, event.message)
        print(f"✅ Forwarded message from {event.chat.title}")
    except Exception as e:
        print(f"⚠️ Error forwarding from {event.chat.title}: {e}")

# Start client
print("🚀 Starting Telegram forwarder...")
client.start()
print("📡 Listening for new messages from source channels...")
client.run_until_disconnected()
