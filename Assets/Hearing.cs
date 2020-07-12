using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class Hearing : MonoBehaviour
{
    public ZombieAI brain;
    bool withinEarshot = false;
    Transform player;

    void Start()
    {
        MoveController.instance.OnShoot += SoundHeard;
    }

    void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            player = other.transform;
            withinEarshot = true;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            player = null;
            withinEarshot = false;
        }
    }

    void SoundHeard()
    {
        if (withinEarshot)
        {
            brain.SoundHeard(player.position);
        }
    }
}
