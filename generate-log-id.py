print('''
      Script para monitorar clique do mouse dentro do VScode.
      Quando o botão é detectado, busca pelo código do projeto e cria uma
      string padrão de identificação dos logs (padrão Will)
      ''')
import pynput
import pygetwindow as gw
import pyautogui
from datetime import datetime
import re

target_button = pynput.mouse.Button.middle  # se quiser trocar o botão, esse pe o lugar

def on_click(x, y, button, pressed):
    if pressed and button == target_button:
        active_window = gw.getActiveWindow()
        if active_window:
            if 'Visual Studio Code' in active_window.title:
                window_title = active_window.title.split(' - ')[1]
                match = re.match(r'^(\d{5})', window_title)
                if match: # Verifica se o título da janela começa com um código de projeto (5 dígitos)
                    project_code = match.group(1)
                    timestamp = datetime.now().strftime('%y%m%d%H%M%S')
                    new_string = f"{project_code}_{timestamp}"
                    pyautogui.write(new_string)

print("iniciando o listener do mouse...")
with pynput.mouse.Listener(on_click=on_click) as listener:
    listener.join()
