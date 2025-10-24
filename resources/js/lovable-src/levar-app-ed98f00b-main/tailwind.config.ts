import type { Config } from "tailwindcss";

export default {
  darkMode: ["class"],
  content: ["./pages/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}", "./app/**/*.{ts,tsx}", "./src/**/*.{ts,tsx}"],
  prefix: "",
  theme: {
    container: {
      center: true,
      padding: "2rem",
      screens: {
        "2xl": "1400px",
      },
    },
    extend: {
      colors: {
        border: "hsl(var(--border))",
        input: "hsl(var(--input))",
        ring: "hsl(var(--ring))",
        background: "hsl(var(--background))",
        foreground: "hsl(var(--foreground))",
        primary: {
          DEFAULT: "hsl(var(--primary))",
          foreground: "hsl(var(--primary-foreground))",
        },
        secondary: {
          DEFAULT: "hsl(var(--secondary))",
          foreground: "hsl(var(--secondary-foreground))",
        },
        destructive: {
          DEFAULT: "hsl(var(--destructive))",
          foreground: "hsl(var(--destructive-foreground))",
        },
        muted: {
          DEFAULT: "hsl(var(--muted))",
          foreground: "hsl(var(--muted-foreground))",
        },
        accent: {
          DEFAULT: "hsl(var(--accent))",
          foreground: "hsl(var(--accent-foreground))",
        },
        popover: {
          DEFAULT: "hsl(var(--popover))",
          foreground: "hsl(var(--popover-foreground))",
        },
        card: {
          DEFAULT: "hsl(var(--card))",
          foreground: "hsl(var(--card-foreground))",
        },
        catalog: {
          DEFAULT: "hsl(var(--catalog-primary))",
          secondary: "hsl(var(--catalog-secondary))",
          accent: "hsl(var(--catalog-accent))",
        },
        decide: {
          DEFAULT: "hsl(var(--decide-primary))",
          secondary: "hsl(var(--decide-secondary))",
          accent: "hsl(var(--decide-accent))",
        },
        pack: {
          DEFAULT: "hsl(var(--pack-primary))",
          secondary: "hsl(var(--pack-secondary))",
          accent: "hsl(var(--pack-accent))",
        },
        summary: {
          DEFAULT: "hsl(var(--summary-primary))",
          secondary: "hsl(var(--summary-secondary))",
          accent: "hsl(var(--summary-accent))",
        },
      },
      backgroundImage: {
        'gradient-catalog': 'var(--gradient-catalog)',
        'gradient-decide': 'var(--gradient-decide)',
        'gradient-pack': 'var(--gradient-pack)',
        'gradient-summary': 'var(--gradient-summary)',
      },
      boxShadow: {
        'smooth-sm': 'var(--shadow-sm)',
        'smooth-md': 'var(--shadow-md)',
        'smooth-lg': 'var(--shadow-lg)',
      },
      borderRadius: {
        lg: "var(--radius)",
        md: "calc(var(--radius) - 2px)",
        sm: "calc(var(--radius) - 4px)",
      },
      keyframes: {
        "accordion-down": {
          from: {
            height: "0",
          },
          to: {
            height: "var(--radix-accordion-content-height)",
          },
        },
        "accordion-up": {
          from: {
            height: "var(--radix-accordion-content-height)",
          },
          to: {
            height: "0",
          },
        },
      },
      animation: {
        "accordion-down": "accordion-down 0.2s ease-out",
        "accordion-up": "accordion-up 0.2s ease-out",
      },
    },
  },
  plugins: [require("tailwindcss-animate")],
} satisfies Config;
