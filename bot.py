import telebot
TOKEN = "5071712744:AAF4vS5HcfcHwiQu0R0R7LcBT01KiD7plEg"
bot = telebot.TeleBot(TOKEN, parse_mode=None)

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
	bot.reply_to(message, "Мій приклад сервісу для Курсової  роботи")
    print("Ввели команду")


bot.infinity_polling()
