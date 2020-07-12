using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Life : MonoBehaviour
{
    public bool isHead;

    public float hitPointsCurrent = 3, hitPointsMax = 3;

    public bool isDead;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (hitPointsCurrent <= 0)
        {
            isDead = true;
        }
    }

    public void Hit(float damage)
    {
        hitPointsCurrent -= damage;
    }
}
