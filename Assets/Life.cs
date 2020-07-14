using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Life : MonoBehaviour
{
    public bool isHead;

    public float hitPointsCurrent = 3, hitPointsMax = 3;

    public bool isDead;

    public SpriteRenderer sr;

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
        StartCoroutine(HitFeedback());
    }

    IEnumerator HitFeedback()
    {
        sr.material.SetFloat("_HurtFloat", 0);
        yield return new WaitForSecondsRealtime(0.1f);
        sr.material.SetFloat("_HurtFloat", 1);
    }
}
