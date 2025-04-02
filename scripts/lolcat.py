#!/usr/bin/env python3
import sys
import colorsys

def print_rainbow_text(text, freq=0.05, offset=0):
    """
    Print text with smooth rainbow gradient colors.
    
    Args:
        text: The string to print
        freq: Controls how fast colors change (lower = slower gradient)
        offset: Starting position in the color wheel (0 to 1)
    """
    for i, char in enumerate(text):
        if char == '\n':
            print(char, end='')
            continue
            
        # Calculate hue - position in the color spectrum
        hue = (freq * i + offset) % 1.0
        
        # Convert HSV to RGB (full saturation and value for vibrant colors)
        r, g, b = [int(255 * x) for x in colorsys.hsv_to_rgb(hue, 1.0, 1.0)]
        
        # Print colored character using ANSI escape codes
        print(f"\033[38;2;{r};{g};{b}m{char}", end='', flush=True)
    
    # Reset colors
    print("\033[0m", end='')

def lolcat_file(filename=None, freq=0.05, offset=0):
    """Process a file or stdin with rainbow colors"""
    if filename:
        with open(filename, 'r') as file:
            for line in file:
                print_rainbow_text(line, freq, offset)
    else:
        for line in sys.stdin:
            print_rainbow_text(line, freq, offset)

def lolcat_text(text, freq=0.05, offset=0):
    """Process a string with rainbow colors"""
    lines = text.split('\n')
    for i, line in enumerate(lines):
        print_rainbow_text(line, freq, offset)
        if i < len(lines) - 1:
            print()  # Add newline between lines except for the last line

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description='Python implementation of lolcat with smooth gradients')
    parser.add_argument('file', nargs='?', help='File to read (default: stdin)')
    parser.add_argument('-f', '--freq', type=float, default=0.05,
                        help='Frequency of color change (default: 0.05, lower = smoother)')
    parser.add_argument('-o', '--offset', type=float, default=0,
                        help='Color offset (0.0-1.0)')
    
    args = parser.parse_args()
    
    if args.file:
        lolcat_file(args.file, args.freq, args.offset)
    else:
        lolcat_file(None, args.freq, args.offset)