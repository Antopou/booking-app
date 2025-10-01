package com.example.booking_agency.data.datasource.local

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import com.example.booking_agency.data.datasource.local.dao.BookingDao
import com.example.booking_agency.data.datasource.local.dao.RoomDao
import com.example.booking_agency.data.datasource.local.dao.UserDao
import com.example.booking_agency.data.datasource.local.dao.UserSessionDao
import com.example.booking_agency.data.datasource.local.entity.BookingEntity
import com.example.booking_agency.data.datasource.local.entity.RoomEntity
import com.example.booking_agency.data.datasource.local.entity.UserEntity
import com.example.booking_agency.data.datasource.local.entity.UserSessionEntity
import java.util.Date

/**
 * Room database for RoomBooker Pro
 * Handles local data storage and caching
 */
@Database(
    entities = [
        UserEntity::class,
        RoomEntity::class,
        BookingEntity::class,
        UserSessionEntity::class
    ],
    version = 1,
    exportSchema = false
)
@TypeConverters(DateConverter::class)
abstract class RoomBookerDatabase : RoomDatabase() {

    abstract fun userDao(): UserDao
    abstract fun roomDao(): RoomDao
    abstract fun bookingDao(): BookingDao
    abstract fun userSessionDao(): UserSessionDao

    companion object {
        private const val DATABASE_NAME = "roombooker_pro.db"

        @Volatile
        private var INSTANCE: RoomBookerDatabase? = null

        fun getInstance(context: Context): RoomBookerDatabase {
            return INSTANCE ?: synchronized(this) {
                INSTANCE ?: buildDatabase(context).also { INSTANCE = it }
            }
        }

        private fun buildDatabase(context: Context): RoomBookerDatabase {
            return Room.databaseBuilder(
                context.applicationContext,
                RoomBookerDatabase::class.java,
                DATABASE_NAME
            )
            .fallbackToDestructiveMigration() // For development only
            .build()
        }
    }
}

/**
 * Type converter for Date objects
 */
class DateConverter {
    @androidx.room.TypeConverter
    fun fromTimestamp(value: Long?): Date? {
        return value?.let { Date(it) }
    }

    @androidx.room.TypeConverter
    fun dateToTimestamp(date: Date?): Long? {
        return date?.time
    }
}
