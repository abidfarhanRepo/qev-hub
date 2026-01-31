'use client'

import { motion } from 'framer-motion'
import { Zap, Shield, Globe, Smartphone } from 'lucide-react'

const features = [
  {
    icon: Zap,
    title: "High Performance",
    description: "Instant torque and acceleration that redefines driving dynamics."
  },
  {
    icon: Shield,
    title: "Advanced Safety",
    description: "Next-gen collision avoidance and autonomous safety systems."
  },
  {
    icon: Globe,
    title: "Eco-Conscious",
    description: "Zero emissions without compromising on luxury or power."
  },
  {
    icon: Smartphone,
    title: "Smart Connectivity",
    description: "Seamless integration with your digital life and smart home."
  }
]

export default function FeaturesSection() {
  return (
    <section className="py-24 bg-background relative overflow-hidden">
       {/* Background Elements */}
       <div className="absolute inset-0 bg-muted/20" />
       <div className="absolute top-0 left-0 w-full h-full bg-[radial-gradient(circle_at_center,_var(--tw-gradient-stops))] from-primary/10 via-transparent to-transparent opacity-60" />

      <div className="container px-4 md:px-6 relative z-10">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          whileInView={{ opacity: 1, y: 0 }}
          viewport={{ once: true }}
          transition={{ duration: 0.6 }}
          className="text-center mb-16"
        >
          <h2 className="text-3xl md:text-5xl font-bold text-foreground uppercase tracking-wider mb-4">
            Engineering <span className="text-primary">Excellence</span>
          </h2>
          <div className="h-1 w-24 bg-primary mx-auto rounded-full shadow-lg" />
        </motion.div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {features.map((feature, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 30 }}
              whileInView={{ opacity: 1, y: 0 }}
              viewport={{ once: true }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
              className="group p-6 border border-border bg-card hover:bg-muted/20 hover:border-primary/50 transition-all duration-300 rounded-xl shadow-lg hover:shadow-xl hover:-translate-y-2"
            >
              <div className="mb-4 p-3 bg-primary/10 rounded-lg w-fit group-hover:bg-primary group-hover:shadow-md transition-all">
                <feature.icon className="w-8 h-8 text-primary group-hover:text-primary-foreground" />
              </div>
              <h3 className="text-xl font-bold text-foreground mb-2 group-hover:text-primary transition-colors">{feature.title}</h3>
              <p className="text-foreground/80 leading-relaxed">{feature.description}</p>
            </motion.div>
          ))}
        </div>
      </div>
    </section>
  )
}
