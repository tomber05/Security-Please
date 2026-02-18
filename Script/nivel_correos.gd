extends Control

# --- NODE REFERENCES ---
# Make sure the names on the left (Scene Tree) match these paths
@onready var email_list_ui = $MainSplit/InboxContainer/EmailList
@onready var sender_label = $MainSplit/EmailViewer/EmailContent/Sender
@onready var subject_label = $MainSplit/EmailViewer/EmailContent/Subject
@onready var body_rich_text = $MainSplit/EmailViewer/EmailContent/BodyText
@onready var manual_panel = $ManualPanel
@onready var manual_content = $ManualPanel/ManualContent

# --- STATE VARIABLES ---
var selected_email = null

# --- EMAIL DATABASE ---
var emails = [
	{
		"sender": "Support <security@paypa1.com>",
		"subject": "Account Suspended",
		"body": "We detected unusual activity. Please verify your identity at this link.",
		"is_phishing": true,
		"explanation": "The domain paypa1.com uses a '1' instead of an 'l'. It's fake!"
	},
	{
		"sender": "IT Boss <it@yourcompany.com>",
		"subject": "Password Update",
		"body": "Remember your network key expires tomorrow. Change it in the official control panel.",
		"is_phishing": false,
		"explanation": "This is a legitimate email from the IT department."
	}
]

# --- MAIN FUNCTIONS ---

func _ready():
	# Initial setup when the game starts
	body_rich_text.bbcode_enabled = true
	manual_panel.visible = false # Manual starts hidden
	
	# Set manual text via code (or you can do it in the editor)
	manual_content.text = "[b]SECURITY MANUAL[/b]\n\n" + \
		"1. Banks never ask for passwords via email.\n" + \
		"2. Check that the domain is exact (e.g., google.com, not gooogle.com).\n" + \
		"3. Phishing emails often use urgency or fear."

	_generate_email_list()

func _generate_email_list():
	# Creates a button in the list for each email in our database
	for email in emails:
		var btn = Button.new()
		btn.text = email["subject"]
		btn.pressed.connect(func(): _display_email(email))
		email_list_ui.add_child(btn)

func _display_email(data):
	# Shows the content of the selected email in the viewer
	selected_email = data
	sender_label.text = "FROM: " + data["sender"]
	subject_label.text = "SUBJECT: " + data["subject"]
	body_rich_text.text = data["body"]

# --- MANUAL LOGIC ---

func _on_btn_manual_pressed():
	# Shows the panel
	manual_panel.visible = true

func _on_btn_cerrar_manual_pressed():
	# Hides the panel
	manual_panel.visible = false

# --- DECISION LOGIC (STAMPS) ---

func _on_btn_legitimo_pressed():
	_evaluate_decision(false) # Player says it's safe

func _on_btn_phishing_pressed():
	_evaluate_decision(true) # Player says it's phishing

func _evaluate_decision(player_suspects_phishing):
	if selected_email == null:
		print("Select an email first.")
		return
	
	if player_suspects_phishing == selected_email["is_phishing"]:
		print("CORRECT! You identified the email correctly.")
	else:
		print("ERROR: " + selected_email["explanation"])
