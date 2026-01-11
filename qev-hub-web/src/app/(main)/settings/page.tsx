'use client'

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { User, Bell, ShieldIcon, CreditCardIcon } from '@/components/icons'

export default function SettingsPage() {
  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 relative z-10">
        <div className="mb-8">
          <h1 className="text-4xl font-black uppercase tracking-widest text-foreground mb-2">
            Settings
          </h1>
          <p className="text-muted-foreground">
            Manage your account settings and preferences
          </p>
        </div>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <Card className="bg-card/50 border-border backdrop-blur-md hover:border-primary/50 transition-all cursor-pointer">
            <CardHeader>
              <div className="flex items-center gap-3 mb-2">
                <User className="h-6 w-6 text-primary" />
                <CardTitle className="text-xl">Profile Settings</CardTitle>
              </div>
              <CardDescription>
                Update your personal information and profile details
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Button variant="outline" className="w-full">
                Edit Profile
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-card/50 border-border backdrop-blur-md hover:border-primary/50 transition-all cursor-pointer">
            <CardHeader>
              <div className="flex items-center gap-3 mb-2">
                <Bell className="h-6 w-6 text-primary" />
                <CardTitle className="text-xl">Notifications</CardTitle>
              </div>
              <CardDescription>
                Configure how you receive notifications about orders and updates
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Button variant="outline" className="w-full">
                Manage Notifications
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-card/50 border-border backdrop-blur-md hover:border-primary/50 transition-all cursor-pointer">
            <CardHeader>
              <div className="flex items-center gap-3 mb-2">
                <ShieldIcon className="h-6 w-6 text-primary" />
                <CardTitle className="text-xl">Security</CardTitle>
              </div>
              <CardDescription>
                Manage your password, two-factor authentication, and security settings
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Button variant="outline" className="w-full">
                Security Settings
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-card/50 border-border backdrop-blur-md hover:border-primary/50 transition-all cursor-pointer">
            <CardHeader>
              <div className="flex items-center gap-3 mb-2">
                <CreditCardIcon className="h-6 w-6 text-primary" />
                <CardTitle className="text-xl">Payment Methods</CardTitle>
              </div>
              <CardDescription>
                Add or remove payment methods for your purchases
              </CardDescription>
            </CardHeader>
            <CardContent>
              <Button variant="outline" className="w-full">
                Manage Payment Methods
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
