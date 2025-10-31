#!/usr/bin/env python3
"""
Sophie AI Testing Tool
Easily test VAPI text and voice agents with conversation history tracking
"""

import json
import requests
import sys
import os
from datetime import datetime

# VAPI Configuration
ASSISTANT_ID = "cb76e1bc-dc2d-4ea8-84a1-c17499ed6387"
API_KEY = "bb0b198b-1a8f-4675-bdf8-8a865fc5d68a"
API_ENDPOINT = "https://api.vapi.ai/chat"
CHAT_ID_FILE = "/tmp/vapi_chat_id.txt"
HISTORY_FILE = "/tmp/vapi_conversation_history.json"

# Colors for better readability
class Colors:
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    END = '\033[0m'

def load_chat_id():
    try:
        with open(CHAT_ID_FILE, 'r') as f:
            return f.read().strip()
    except FileNotFoundError:
        return None

def save_chat_id(chat_id):
    with open(CHAT_ID_FILE, 'w') as f:
        f.write(chat_id)

def load_history():
    try:
        with open(HISTORY_FILE, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return []

def save_history(history):
    with open(HISTORY_FILE, 'w') as f:
        json.dump(history, f, indent=2)

def send_message(message, quiet=False):
    if not quiet:
        print(f"\n{Colors.BOLD}{'=' * 80}{Colors.END}")
        print(f"{Colors.BLUE}{Colors.BOLD}YOU:{Colors.END} {message}")
        print(f"{Colors.BOLD}{'=' * 80}{Colors.END}")

    # Build payload
    payload = {
        "assistantId": ASSISTANT_ID,
        "input": message
    }

    # Add previous chat ID if exists
    chat_id = load_chat_id()
    if chat_id:
        payload["previousChatId"] = chat_id
        if not quiet:
            print(f"{Colors.YELLOW}[Continuing conversation: {chat_id[:20]}...]{Colors.END}")
    else:
        if not quiet:
            print(f"{Colors.YELLOW}[Starting new conversation]{Colors.END}")

    # Make API call
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}"
    }

    try:
        response = requests.post(API_ENDPOINT, json=payload, headers=headers, timeout=30)
        response.raise_for_status()
        data = response.json()

        # Save full response for debugging
        with open('/tmp/last_vapi_response.json', 'w') as f:
            json.dump(data, f, indent=2)

        # Save chat ID (VAPI uses 'id' not 'chatId')
        if 'id' in data:
            save_chat_id(data['id'])

        # Extract Sophie's response
        sophie_response = None
        if 'output' in data and isinstance(data['output'], list) and len(data['output']) > 0:
            sophie_response = data['output'][-1].get('content') or data['output'][-1].get('text')
        elif 'messages' in data and isinstance(data['messages'], list) and len(data['messages']) > 0:
            sophie_response = data['messages'][-1].get('content') or data['messages'][-1].get('text')
        elif 'response' in data:
            sophie_response = data['response']
        elif 'reply' in data:
            sophie_response = data['reply']

        if not quiet:
            print(f"\n{Colors.GREEN}{Colors.BOLD}SOPHIE:{Colors.END} {sophie_response or 'No response'}\n")

        # Update conversation history
        history = load_history()
        history.append({
            "timestamp": datetime.now().isoformat(),
            "user": message,
            "sophie": sophie_response,
            "conversation_id": data.get('id', '')
        })
        save_history(history)

        return sophie_response

    except requests.exceptions.RequestException as e:
        print(f"\n{Colors.RED}ERROR: {e}{Colors.END}\n")
        return None

def reset_conversation():
    try:
        os.remove(CHAT_ID_FILE)
        print(f"{Colors.GREEN}✓ Conversation reset!{Colors.END}")
    except FileNotFoundError:
        print(f"{Colors.YELLOW}No active conversation to reset.{Colors.END}")

def show_history():
    history = load_history()
    if not history:
        print(f"{Colors.YELLOW}No conversation history found.{Colors.END}")
        return

    print(f"\n{Colors.BOLD}{'=' * 80}{Colors.END}")
    print(f"{Colors.BOLD}CONVERSATION HISTORY ({len(history)} messages){Colors.END}")
    print(f"{Colors.BOLD}{'=' * 80}{Colors.END}\n")

    for i, msg in enumerate(history, 1):
        timestamp = datetime.fromisoformat(msg['timestamp']).strftime("%H:%M:%S")
        print(f"{Colors.YELLOW}[{timestamp}]{Colors.END}")
        print(f"{Colors.BLUE}YOU:{Colors.END} {msg['user']}")
        print(f"{Colors.GREEN}SOPHIE:{Colors.END} {msg['sophie']}\n")

def clear_history():
    try:
        os.remove(HISTORY_FILE)
        print(f"{Colors.GREEN}✓ History cleared!{Colors.END}")
    except FileNotFoundError:
        print(f"{Colors.YELLOW}No history to clear.{Colors.END}")

def run_test_suite():
    """Run a complete test suite for Sophie"""
    print(f"\n{Colors.BOLD}{'=' * 80}{Colors.END}")
    print(f"{Colors.BOLD}SOPHIE AI TEST SUITE{Colors.END}")
    print(f"{Colors.BOLD}{'=' * 80}{Colors.END}\n")

    reset_conversation()
    clear_history()

    tests = [
        ("Test 1: Basic Information", "How do solar panels work?"),
        ("Test 2: Cost Inquiry", "What's the average cost?"),
        ("Test 3: EV Scenario", "I have a Tesla Model 3"),
        ("Test 4: Formatting Check", "Tell me about the AIKO panels in detail"),
        ("Test 5: Skepticism", "I've heard solar doesn't work well in the UK"),
    ]

    for test_name, message in tests:
        print(f"\n{Colors.BOLD}{test_name}{Colors.END}")
        print("-" * 80)
        send_message(message)
        input(f"{Colors.YELLOW}Press Enter to continue...{Colors.END}")

    print(f"\n{Colors.GREEN}{Colors.BOLD}✓ Test suite complete!{Colors.END}\n")
    show_history()

def main():
    if len(sys.argv) > 1:
        command = sys.argv[1]

        if command == "--reset":
            reset_conversation()
        elif command == "--history":
            show_history()
        elif command == "--clear":
            reset_conversation()
            clear_history()
        elif command == "--test":
            run_test_suite()
        elif command == "--help":
            print(f"""
{Colors.BOLD}Sophie AI Testing Tool{Colors.END}

Usage:
  python3 /tmp/sophie_tester.py "Your message"     Send a message to Sophie
  python3 /tmp/sophie_tester.py --reset            Reset conversation (keep history)
  python3 /tmp/sophie_tester.py --history          Show conversation history
  python3 /tmp/sophie_tester.py --clear            Clear everything (conversation + history)
  python3 /tmp/sophie_tester.py --test             Run complete test suite
  python3 /tmp/sophie_tester.py --help             Show this help message

Examples:
  python3 /tmp/sophie_tester.py "I'd like a quote"
  python3 /tmp/sophie_tester.py --test
            """)
        else:
            send_message(" ".join(sys.argv[1:]))
    else:
        print(f"{Colors.RED}Error: No message provided{Colors.END}")
        print(f"Use: python3 /tmp/sophie_tester.py --help")

if __name__ == "__main__":
    main()
