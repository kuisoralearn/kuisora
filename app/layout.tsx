import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Kuisora — Hidupkan rasa ingin tahu",
  description: "Studio kuis interaktif untuk setiap cara belajar.",
  icons: {
    icon: "/favicon.svg",
    shortcut: "/favicon.svg",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="id">
      <body className="antialiased">{children}</body>
    </html>
  );
}
