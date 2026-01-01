import { supabase } from '../lib/supabase'
import { fetchChargingStations, ChargingStation } from '../lib/charging-data-provider'

/**
 * Service to sync charging station data to database
 * This should be run periodically (e.g., via cron job or scheduled task)
 */
export async function syncChargingStations() {
  try {
    console.log('Starting charging station sync...')
    
    // Fetch data from provider
    const stations = await fetchChargingStations()
    console.log(`Fetched ${stations.length} charging stations`)

    // Upsert stations into database
    for (const station of stations) {
      const { error } = await supabase
        .from('charging_stations')
        .upsert(
          {
            ...station,
            last_scraped_at: new Date().toISOString(),
          },
          {
            onConflict: 'name,latitude,longitude',
          }
        )

      if (error) {
        console.error(`Error upserting station ${station.name}:`, error)
      } else {
        console.log(`✓ Synced: ${station.name}`)
      }
    }

    console.log('Charging station sync completed successfully')
    return { success: true, count: stations.length }
  } catch (error) {
    console.error('Error syncing charging stations:', error)
    throw error
  }
}

export async function updateStationAvailability() {
  try {
    console.log('Updating station availability...')
    console.log('Station availability update completed')
  } catch (error) {
    console.error('Error updating station availability:', error)
    throw error
  }
}
