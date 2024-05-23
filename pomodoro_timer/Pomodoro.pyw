# Prompt: crie um timer pomodoro com tempos ajustáveis em Python, e com uma interface gráfica bonita, capaz de rodar em Windows e Linux.
# Adequação: will.i.am | github.com/williampilger

import time
import tkinter as tk
from tkinter import messagebox
from tkinter import ttk

class PomodoroTimer:
    def __init__(self, master):
        self.master = master
        self.master.title("Pomodoro Timer")

        # Configuração inicial dos tempos
        self.work_time = 25 * 60  # 25 minutos
        self.short_break_time = 5 * 60  # 5 minutos

        # Estado inicial
        self.time_left = self.work_time
        self.timer_running = False
        self.current_phase = "Work"

        self.create_widgets()
        self.update_timer_display()

    def setToTheTop(self, state:bool):
        self.master.attributes('-topmost', state)

    def create_widgets(self):
        self.timer_label = tk.Label(self.master, text="Pomodoro Timer", font=("Helvetica", 24))
        self.timer_label.pack(pady=1)

        self.time_display = tk.Label(self.master, text="", font=("Helvetica", 48))
        self.time_display.pack(pady=10)

        self.phase_display = tk.Label(self.master, text="Foco", font=("Helvetica", 14))
        self.phase_display.pack(pady=1)

        style = ttk.Style()
        style.configure('TButton', font=('Helvetica', 10), borderwidth='2')
        style.configure('TButton', background='#d3d3d3', foreground='#262626')

        self.button_frame = tk.Frame(self.master)
        self.button_frame.pack(pady=10)

        self.start_button = ttk.Button(self.button_frame, text="Iniciar", command=self.start_timer, style='TButton')
        self.start_button.grid(row=0, column=0, pady=5, padx=5)

        self.reset_button = ttk.Button(self.button_frame, text="Zerar", command=self.reset_timer, style='TButton')
        self.reset_button.grid(row=0, column=1, pady=5, padx=5)

        self.next_button = ttk.Button(self.button_frame, text="Próximo", command=self.next_timer, style='TButton')
        self.next_button.grid(row=1, column=0, pady=5, padx=5)

        self.settings_button = ttk.Button(self.button_frame, text="Ajustes", command=self.open_settings, style='TButton')
        self.settings_button.grid(row=1, column=1, pady=5, padx=5)

        self.ny_label = tk.Label(self.master, text="By: William Pilger", font=("Helvetica", 8))
        self.ny_label.pack(pady=1)

    def start_timer(self):
        if self.timer_running:
            self.setToTheTop(False)
            self.start_button.config(text="Retomar")
            self.timer_running = False
        else:
            self.setToTheTop(True)
            self.start_button.config(text="Pausar")
            self.timer_running = True
            self.start_time = time.perf_counter()
            self.run_timer()

    def reset_timer(self):
        self.setToTheTop(False)
        self.timer_running = False
        self.time_left = self.work_time if self.current_phase == "Work" else self.short_break_time
        self.start_button.config(text="Iniciar")
        self.update_timer_display()

    def run_timer(self):
        if self.timer_running:
            current_time = time.perf_counter()
            elapsed_time = int(current_time - self.start_time)
            self.time_left -= elapsed_time
            self.start_time = current_time
            if self.time_left > 0:
                self.update_timer_display()
                self.master.after(1000, self.run_timer)
            else:
                self.timer_running = False
                self.switch_phase()

    def next_timer(self):
        self.timer_running = False
        if self.current_phase == "Work":
            self.current_phase = "Short Break"
            self.time_left = self.short_break_time
        elif self.current_phase == "Short Break":
            self.current_phase = "Work"
            self.time_left = self.work_time
        self.start_button.config(text="Iniciar")
        self.update_timer_display()
        
    def switch_phase(self):
        self.playAlarm()
        if self.current_phase == "Work":
            if messagebox.askyesno("Pomodoro Timer", "Tempo de concentração acabou! Iniciar uma pausa?"):
                self.current_phase = "Short Break"
                self.time_left = self.short_break_time
                self.start_timer()
        elif self.current_phase == "Short Break":
            if messagebox.askyesno("Pomodoro Timer", "Tempo de pausa acabou! Iniciar novo ciclo de concentração?"):
                self.current_phase = "Work"
                self.time_left = self.work_time
                self.start_timer()

    def update_timer_display(self):
        minutes = self.time_left // 60
        seconds = self.time_left % 60
        self.time_display.config(text=f"{minutes:02}:{seconds:02}")
        self.phase_display.config(text=self.current_phase)

    def open_settings(self):
        self.settings_window = tk.Toplevel(self.master)
        self.settings_window.title("Settings")

        tk.Label(self.settings_window, text="Duração do Foco (minutos):", font=("Helvetica", 14)).pack(pady=5)
        self.work_time_entry = tk.Entry(self.settings_window, font=("Helvetica", 14))
        self.work_time_entry.pack(pady=5)
        self.work_time_entry.insert(0, str(self.work_time // 60))

        tk.Label(self.settings_window, text="Duração da Pausa (minutos):", font=("Helvetica", 14)).pack(pady=5)
        self.short_break_time_entry = tk.Entry(self.settings_window, font=("Helvetica", 14))
        self.short_break_time_entry.pack(pady=5)
        self.short_break_time_entry.insert(0, str(self.short_break_time // 60))

        tk.Button(self.settings_window, text="Save", command=self.save_settings, font=("Helvetica", 14)).pack(pady=10)

    def save_settings(self):
        self.work_time = int(self.work_time_entry.get()) * 60
        self.short_break_time = int(self.short_break_time_entry.get()) * 60
        self.time_left = self.work_time
        self.current_phase = "Work"
        self.update_timer_display()
        self.settings_window.destroy()

    def playAlarm(self):
        
        melody = [
            ('C5', 0.1),
            (' ', 0.1),
            ('C5', 0.1),
            (' ', 0.1),
            ('C5', 0.1)
        ]
        my_melody = Musiquinha(melody)
        my_melody.play()


import simpleaudio as sa
import numpy as np
class Musiquinha:
    
    notes = {
        ' ' : 0,
        'C4': 261.63,
        'C#4': 277.18,
        'D4': 293.66,
        'D#4': 311.13,
        'E4': 329.63,
        'F4': 349.23,
        'F#4': 369.99,
        'G4': 392.00,
        'G#4': 415.30,
        'A4': 440.00,
        'A#4': 466.16,
        'B4': 493.88,
        'C5': 523.25,
        'C#5': 554.37,
        'D5': 587.33,
        'D#5': 622.25,
        'E5': 659.25,
        'F5': 698.46,
        'F#5': 739.99,
        'G5': 783.99,
        'G#5': 830.61,
        'A5': 880.00,
        'A#5': 932.33,
        'B5': 987.77,
        'C6': 1046.50
    }

    def __init__(self, melody):
        self.melody = melody

    def generate_sine_wave(self, frequency, duration, sample_rate=44100, amplitude=0.5):
        t = np.linspace(0, duration, int(sample_rate * duration), False)
        wave = amplitude * np.sin(2 * np.pi * frequency * t)
        return wave

    def play(self):
        melody_wave = np.concatenate([self.generate_sine_wave(self.notes[note], duration) for note, duration in self.melody])
        play_obj = sa.play_buffer(np.int16(melody_wave * 32767), 1, 2, 44100)
        play_obj.wait_done()
    

if __name__ == "__main__":
    root = tk.Tk()
    app = PomodoroTimer(root)
    root.mainloop()
